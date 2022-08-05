%Created on Thu Jul 17 17:47:23 2022
%@Author: Guichemerre Alexis
%Download video via database SPORT1M. Fromat 480x320 => encoding HEVC HM
%and QP37 with 1 packet per Frame.

function []= Run_Python(n)
    VideoRoute = append('D:\CNN_Ranking_ListDecoding\DatabaseVideoCandidates\QP37\video_',int2str(n),"\HEVC\encoding");
    VideoTempNameFile = append('video','_','temp','_',int2str(n));
    PathVideo = append(VideoRoute,'\',VideoTempNameFile,'.mp4');
    RawsequenceRoute = 'D:\CNN_Ranking_ListDecoding\DatabaseVideoCandidates\QP37\rawSequence';
    
    VideoCutNameFile = append('video','_',int2str(n),'_','notresize');
    VideoCutNameFileResize = append('video','_',int2str(n));
    VideoYUVNameFile = append('video_',int2str(n),'_cif');
    
    %Python part
    PythonscriptRoute = 'D:/CNN_Ranking_ListDecoding/PythonCode/read_txtfile.py ';
    PythonCommand = append(PythonscriptRoute, int2str(n));
    
    % Launch Python code named read_txtfile => Read the .txt file with the
    % url selected.
    system(PythonCommand);

    if exist(PathVideo, 'file') == 2
        video=VideoReader(PathVideo);
        if (video.Height >= 320 && video.Width >= 480)
            
            %Cut Video
            CutVideoCommand = append('ffmpeg -i ',PathVideo,' ','-ss 00:00:00 -to 00:00:01 -async 1',' ', VideoRoute,'\',VideoCutNameFile,'.mp4');
            system(CutVideoCommand);
            ResizeVideoCommand = append('ffmpeg -i ',VideoRoute,'\',VideoCutNameFile,'.mp4',' -vf scale=448:320 ',VideoRoute,'\',VideoCutNameFileResize,'.mp4');
            system(ResizeVideoCommand)
            
            %YUV file
            YUVCommand = append('ffmpeg -i ',VideoRoute,'\',VideoCutNameFileResize,'.mp4',' ',VideoRoute,'\',VideoYUVNameFile,'.yuv');
            system(YUVCommand);
    
            %Copy file => RawSequence
            copyfile(append(VideoRoute,'\',VideoYUVNameFile,'.yuv'),append(RawsequenceRoute,'\',VideoYUVNameFile,'.yuv'));
    
            %Delete temporary video file
            DeleteCommandTemp = append('del',' ', PathVideo);
            system(DeleteCommandTemp);

            %Delete notresize video file
            DeleteCommandNotResize = append(VideoRoute,"\", VideoCutNameFile,'.mp4');
            delete(DeleteCommandNotResize);
            %{
videocmd = append('ffmpeg -f rawvideo -vcodec rawvideo -s 480x320 -pix_fmt yuv420p -i  ',VideoRoute,'\video_121_qp37.yuv ','-c:v libx264 -preset slow -qp 37 ', VideoRoute,'\','output.mp4');
            system(videocmd);
%}

    end
end