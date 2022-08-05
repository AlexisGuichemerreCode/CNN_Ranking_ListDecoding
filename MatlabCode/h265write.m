function h265write(fid,p)
%H264WRITE Append an RTP packet to H.264 stream (file)

fwrite(fid,p,'ubit1',0,'ieee-be');