#Created on Thu Jul 17 17:47:23 2022
#Author: Guichemerre Alexis
#ReadFile and download video from youtube


import sys
import os
import pytube	# Package YOUTUBE
# from _future_ import unicode_literals
import youtube_dl
import shutil

def readfile(i):
	# open a file for reading:
	file = open(r"D:\CNN_Ranking_ListDecoding\ExcelDbUrl\original\train_partition.txt", "r")
	alllines = file.readlines()
	print(alllines[i].split()[0])
	return(alllines[i].split()[0])


def downloadfile(video_name,a):
	path = "D:/CNN_Ranking_ListDecoding/DatabaseVideoCandidates/QP37/video_"+str(a)+"/HEVC/encoding/video_temp_"+str(a)+".%(ext)s"
	ydl_opts = {'format':'134','outtmpl': path}
	# ydl_opts = {'format':'136','outtmpl': path}
	with youtube_dl.YoutubeDL(ydl_opts) as ydl:
		try:
			ydl.download([video_name])
		# ydl.YoutubeDL( params={'-c': '', '--no-mtime': '', 'outtmpl': './%(uploader)s/%(title)s-%(upload_date)s-%(id)s.%(ext)s'} ).download([url])
		except youtube_dl.utils.DownloadError as e:
			print (e)


if __name__ == "__main__":
	a = int(sys.argv[1])
	path = "D:/CNN_Ranking_ListDecoding/DatabaseVideoCandidates/QP37/video_"+str(a)+"/HEVC/encoding/"
	try:
		os.makedirs(os.path.dirname(path), exist_ok=True)
	except OSError as error:
		print(error)
	print(path)
	name = readfile(a)
	downloadfile(name,a)