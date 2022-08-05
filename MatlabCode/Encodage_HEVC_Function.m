function [] = Encodage_HEVC_Function(QPlist,video_name,video_cif,video_info,n)
%% Inputs
MainRouteResult='D:\CNN_Ranking_ListDecoding'; % folder path
RawSequenceRoute ='D:\CNN_Ranking_ListDecoding\DatabaseVideoCandidates\QP37';
cfgRoute=MainRouteResult;
EncoderExeRoute= [MainRouteResult '\MatlabCode\EncoderHEVC'];
OriginalYuvRoute=[ RawSequenceRoute '\rawSequence'];


cfgName='encoder_lowdelay_main'; %General coding parameter file name


NbCodedFrames = 10;
ImageWidth = int64(video_info.width);
ImageHeight = int64(video_info.height);
FramesRates = int64(video_info.FrameRate);

SEQUENCE_NAME=video_name; % any name
OriginalYuvName=video_cif; % raw yuv seq name
OutRouteResult=[append('D:\CNN_Ranking_ListDecoding\DatabaseVideoCandidates\QP37\video_',int2str(n),'\HEVC\encoding')];

%NbCTUInSlice=ImageWidth/64;
NbCTUInSlice=3;
% FileInfoName = append(OutRouteResult,'\', SEQUENCE_NAME, '_encoding_info.txt')
% if (~exist([ FileInfoName]))
%         mkdir([FileInfoName])
% end

fileID = fopen([OutRouteResult '\' SEQUENCE_NAME '_encoding_info.txt'],'w');
fprintf(fileID,'%s \t\t %s \t\t %s \t\t %s\r\n','QP','Bitrate(kb/s)','NbMBInSlice','NbCodedFrames');
fprintf(fileID,'%s \r\n','*****************************************************************************');

%% copy original.yuv and  cfg files into Matlab Encoder Exe folder
copyfile([OutRouteResult '\' OriginalYuvName '.yuv'  ],[EncoderExeRoute '\' OriginalYuvName '.yuv']);
copyfile([cfgRoute '\' cfgName '.cfg'  ],[EncoderExeRoute '\' cfgName '.cfg']);

cd([EncoderExeRoute]);

%% start encoding for each qp
for i=1: length(QPlist)
    QP=QPlist(i);
    %mkdir([OUTPUT_DIR '\' SEQUENCE_NAME '\qp' int2str(QP) ])

    LENCOD_EXE = [EncoderExeRoute '\TAppEncoder.exe'];
    Command_string= [ '"' LENCOD_EXE '"' ];
    %% change cfg file
    Command_string=[Command_string ' -c "' cfgRoute '\' cfgName  '.cfg" '];
    Command_string=[Command_string ' -c "' cfgRoute '\encoder_lowdelay_main.cfg" '];
    Command_string=[Command_string ' --InputFile="' OriginalYuvName '.yuv "'];
    Command_string=[Command_string ' --SourceWidth=' int2str(ImageWidth) ' --SourceHeight=' int2str(ImageHeight)];
    %Command_string=[Command_string ' --OutputWidth=' int2str(ImageWidth) ' --OutputHeight=' int2str(ImageHeight)];
    Command_string=[Command_string ' --FramesToBeEncoded=' int2str(NbCodedFrames) ];
    Command_string=[Command_string ' --BitstreamFile=' OutRouteResult '\' SEQUENCE_NAME '_qp' int2str(QP) '.265'];
    Command_string=[Command_string ' --ReconFile=' OutRouteResult '\' SEQUENCE_NAME '_qp' int2str(QP) '.yuv'];
    %Command_string=[Command_string ' -p TraceFile=\"' OutRouteResult '\' SEQUENCE_NAME '_qp' int2str(QP) '.trace.txt\"'];
    %Command_string=[Command_string ' -p StatsFile=\"' OutRouteResult '\' SEQUENCE_NAME '_qp' int2str(QP) '.stats.txt\"'];
    Command_string=[Command_string ' --QP=' int2str(QP) ];
    %Command_string=[Command_string '--IntraPeriod=30'];
    Command_string=[Command_string ' --FrameRate=' int2str(FramesRates)];
    Command_string=[Command_string ' --SliceMode=0' ];
    Command_string=[Command_string ' --SliceArgument=1500' ];
    %Command_string=[Command_string ' -p IntraPeriod=0' ]; % only first I other P: IPPP...


    
    
    [status ExCode]=system(Command_string);

    if (status)
        error(['Command TAppEncoder did not complete successfully (return code ' int2str(status) '); Command was' Command_string]);
    end

    po=findstr(ExCode,'Bit rate (kbit/s)' );
    line=ExCode(1,po:end);
    po_1=findstr(line,':');
    po_2=findstr(line ,'Bits to avoid Startcode Emulation' ) ;
    bitrate_str=(line(1,po_1+1:po_2-1));
    bitrate=round(str2num(bitrate_str));

    fprintf(fileID,'%d \t\t %d \t\t\t %d \t\t\t %d\r\n',QP,bitrate,NbCTUInSlice,NbCodedFrames);
end
fprintf(fileID,'%s \r\n','*****************************************************************************');
fclose(fileID);

fclose('all')

%% delete exta file in EncoderExeRoute

delete([EncoderExeRoute '\' OriginalYuvName '.yuv']);
delete([EncoderExeRoute '\' cfgName '.cfg']);
fprintf('Check the following route, delete extra files there \n');
fprintf('%s\n', EncoderExeRoute);
fprintf('done\n');

%

end
