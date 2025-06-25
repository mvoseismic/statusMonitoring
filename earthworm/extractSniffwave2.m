% extract data rate and amount from sniffwave latency datafiles

clear;
tic

%dirData = "/mnt/mvofls2/Seismic_Data/monitoring_data/status";
dirData = "../../data";

dinfo = dir(fullfile(dirData,'data_latency_sniffwave', 'M*'));
ncha = length( dinfo );

rightNow = datetime("now");

for i = 1 : ncha

    dirinfoData = dinfo(i).name;
    dirDataLatency = fullfile( dirData, 'data_latency_sniffwave', dirinfoData );
    dinfo2 = dir(fullfile(dirDataLatency,'*.txt'));

    fileTransferSniffwave = fullfile( dirData, 'data_transfer_sniffwave', sprintf( "%s-winston1.txt", dirinfoData ) );
    
    LL = [];

    fprintf( "%s\n", fileTransferSniffwave );
    for j = 1: length( dinfo2 )

        fileDataLatency = dinfo2(j).name;
        fileDataLatency = fullfile( dirDataLatency, fileDataLatency );
        L = readmatrix( fileDataLatency );
        if numel(L) > 0
            LL = [LL; L];
        end

    end

    if numel(LL) > 0

        fileId = fopen( fileTransferSniffwave, 'w' );

        datimData = LL(:,1);
        bytesData = LL(:,2);
        latencyData = LL(:,3);
        datimArrived = LL(:,1) + latencyData;

        bytesData( isnan( bytesData ) ) = 0;

        minDatimArrived = min( datimArrived );
        maxDatimArrived = max( datimArrived );

        begDatimArrived = 3600 * floor( minDatimArrived/3600 );
        endDatimArrived = 3600 * floor( maxDatimArrived/3600 );

        for datimHour = begDatimArrived:endDatimArrived

            idWant = datimArrived >= datimHour & datimArrived < datimHour+3600;

            kbytesHour = sum( bytesData(idWant) ) / 1024 / 1024;
       

            fprintf( fileId, "%d  %13.6f\n", datimHour+1800, kbytesHour );

        end

        fclose( fileId );

    end


end

toc