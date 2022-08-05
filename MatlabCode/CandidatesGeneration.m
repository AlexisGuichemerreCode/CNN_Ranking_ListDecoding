%Created on Thu Jul 17 17:47:23 2022
%@Author: Guichemerre Alexis
%Add an error in the Intra Packet


function [] = CandidatesGeneration(video_name)
    CandidatesRoute = "D:\CNN_Ranking_ListDecoding";
    CandidatesFolder = "Candidates";
    MainResultRoute='D:\CNN_Ranking_ListDecoding\DatabaseVideoCandidates\QP37';
    SEQUENCE_NAME = video_name;
    Codec = "HEVC";
    
    % make folder for work
    if (~exist(CandidatesRoute+'\'+CandidatesFolder))
        mkdir(CandidatesRoute+'\'+CandidatesFolder)
    end


    %% Inputs:
    CodeRoute='D:\CNN_Ranking_ListDecoding\MatlabCode';
    if Codec=="HEVC"
        DecoderRoute='D:\CNN_Ranking_ListDecoding\MatlabCode\DecoderHEVC';
    end

    OriginalYUVRoute='D:\CNN_Ranking_ListDecoding\DatabaseVideoCandidates\QP37\rawSequence';
    In265Route=append(MainResultRoute,'\',SEQUENCE_NAME,'\HEVC\encoding');

    
%     Qp = 22;
    Qp = 37;

    inputyuv=append(In265Route,'\',SEQUENCE_NAME,'_qp',string(Qp),'.yuv');

    OutImg = append(In265Route,'\',SEQUENCE_NAME,'.png');
    save_yuvframe(inputyuv ,[448 320], 1, OutImg);

    inputfile1=append(In265Route,'\',SEQUENCE_NAME,'_qp',string(Qp),'.265');
    disp(inputfile1);
    FileIDScan = fopen(inputfile1,'r');
    scanTab = scanHEVC(FileIDScan);
    TotalPacket = size(scanTab,2);
    scanTab = scanTab(1:TotalPacket); 
    fclose(FileIDScan);
    % 
    % 
    InputData = fopen(inputfile1,'r');

    pBit1 = fread(InputData,scanTab(1)*8,'ubit1','ieee-be');
    pBit2 = fread(InputData,scanTab(2)*8,'ubit1','ieee-be');
    pBit3 = fread(InputData,scanTab(3)*8,'ubit1','ieee-be');

    pBitHeader = {pBit1, pBit2, pBit3};

    fclose(InputData);

    PacketNum = 4;
%     pos_Error = int64(scanTab(PacketNum)*8*rand(1));
    pos_Error = int64(scanTab(PacketNum)*8*0.4);
    InputData = fopen(inputfile1,'r');
    for i = pos_Error : pos_Error
        OutputFile = append(CandidatesRoute,'\',CandidatesFolder,'\',SEQUENCE_NAME,"_",string(i),"_01.265");
        edit(OutputFile);
        OutputData = fopen(OutputFile,'w');
        for j = 1 : TotalPacket
            if j <= 3
                h265write(OutputData,cell2mat(pBitHeader(j)));
            else
                pBit=fread(InputData,scanTab(j)*8,'ubit1','ieee-be'); 
                if j == PacketNum
                    pBitchanged=pBit; 
                    pBitchanged(i) = abs(pBitchanged(i)+(-1));
                    h265write(OutputData,pBitchanged);
                else
                    h265write(OutputData,pBit);
                end
            end
        end
        fclose(OutputData);
        OutYuv = append(CandidatesRoute,'\',CandidatesFolder,'\',SEQUENCE_NAME,'_damaged_04.yuv');
        try
            system(append('ffmpeg -ec 0 -i ',OutputFile,' ',OutYuv));
        catch
            warning('Can t decode the video');
        end
    end
    fclose(InputData);
    if exist(OutYuv, 'file') == 2
        OutImg = append(CandidatesRoute,'\',CandidatesFolder,'\',SEQUENCE_NAME,'.png');
        save_yuvframe(OutYuv ,[448 320], 1, OutImg);
        OutImg = append(In265Route,'\',SEQUENCE_NAME,'_damaged_04.png');
        save_yuvframe(OutYuv ,[448 320], 1, OutImg);
end
