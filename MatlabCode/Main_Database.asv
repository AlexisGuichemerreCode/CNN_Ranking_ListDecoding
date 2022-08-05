%Created on Thu Jul 17 17:47:23 2022
%@Author: Guichemerre Alexis
%DataBase Generation H.265 Intra frames with intact and degraded one due to
%a flipped bit

clc
clear all
fclose('all');
tic

QP=37;

%Creation of a folder to stock DataBase with a subfolder for QP37

if (~exist('D:\CNN_Ranking_ListDecoding\DatabaseVideoCandidates'))
        mkdir('D:\CNN_Ranking_ListDecoding\DatabaseVideoCandidates')
end

if (~exist('D:\CNN_Ranking_ListDecoding\DatabaseVideoCandidates\QP37'))
        mkdir('D:\CNN_Ranking_ListDecoding\DatabaseVideoCandidates\QP37')
end


PathName = 'D:\CNN_Ranking_ListDecoding\MatlabCode\DataBaseVideoCandidates';
DatabaseRoute = append('D:\CNN_Ranking_ListDecoding\DatabaseVideoCandidates\QP37');

%Number of video needed to create the DataBase
for i = 1:1
    VideoFolder = append(DatabaseRoute,'\','video_',int2str(i),"\HEVC\encoding");
    
    %Download the video from the 1MSport Database
    Run_Python(i);
    
    %Define VideoName, VideoCifName and Video Path
    VideoNameFile = append('video_',int2str(i));
    VideoCifNameFile = append('video_',int2str(i),'_cif');
    VideoPath = append(VideoFolder,'\',VideoNameFile,'.mp4');
    
    if exist(VideoPath, 'file') == 2
    	VideoInfo = VideoReader(VideoPath);
        
        %Encoding video in HEVC/H.265 Format
        Encodage_HEVC_Function(QP,VideoNameFile,VideoCifNameFile,VideoInfo,i);
        
        %Adding an error in the first Intra image (A random bit is flipped)
        CandidatesGeneration(VideoNameFile);
        
    end
end


toc
