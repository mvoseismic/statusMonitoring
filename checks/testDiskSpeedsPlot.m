close all;
clear;
setup = setupGlobals();

fileNetworkSpeedsRead = fullfile( setup.DirStatusMonitoring, 'network', 'network_disks_read_speed.txt' );
fileNetworkSpeedsWrite = fullfile( setup.DirStatusMonitoring, 'network', 'network_disks_write_speed.txt' );

NSR = readtable( fileNetworkSpeedsRead );
readWhen = datetime( NSR.Var1, 'ConvertFrom', 'posixtime');
readDisk = NSR.Var2;
readAmount = NSR.Var12;
readAmountUnits = NSR.Var13;
idSlow = strcmp(readAmountUnits,'kB/s');
readAmount(idSlow) = readAmount(idSlow) / 1024;
idSlow = strcmp(readAmountUnits,'B/s');
readAmount(idSlow) = readAmount(idSlow) / 1024 / 1024;

NSW = readtable( fileNetworkSpeedsWrite );
writeWhen = datetime( NSW.Var1, 'ConvertFrom', 'posixtime');
writeDisk = NSW.Var2;
writeAmount = NSW.Var12;
writeAmountUnits = NSW.Var13;
idSlow = strcmp(writeAmountUnits,'kB/s');
writeAmount(idSlow) = writeAmount(idSlow) / 1024;
idSlow = strcmp(writeAmountUnits,'B/s');
writeAmount(idSlow) = writeAmount(idSlow) / 1024 / 1024;

allDisks = [ readDisk; writeDisk ];
disks = fileparts( unique( allDisks ) );
nDisks = length( disks);

figure;
figure_size( 'l' );
tiledlayout( 'vertical' );

allWhens = [ readWhen; writeWhen ];
tLim1 = dateshift(min(allWhens),'start','week');
tLim2 = dateshift(max(allWhens),'end','week');
tLimits = [  tLim1 tLim2 ];

for iDisk=1:length(disks)
    disk=disks{iDisk};
    fprintf( "%s\n", disk );
    nexttile();
    idWant = contains( readDisk, disk );
    plot( readWhen(idWant), readAmount(idWant), 'ko', 'MarkerFaceColor', 'r' );
    hold on;
    idWant = contains( writeDisk, disk );
    plot( writeWhen(idWant), writeAmount(idWant), 'ko', 'MarkerFaceColor', 'b' );
    title( disk, 'Interpreter', 'none' );
    ylabel( 'MB/s' );
    legend( {'Read speed', 'Write speed'}, 'Location', 'northwest' );
    xlim( tLimits );
end