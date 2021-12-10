[filename , pathname]= uigetfile({'*.raw'},'open');
if isequal(filename,0) || isequal(pathname,0)
errordlg('file not open','open error');
end
file_path =fullfile(pathname,filename);
width =1920;
height=1080;
bit_depth='12bit';
bayerpattern='rggb';
blc_mat = 240*ones(1080,1920);
FileID = fopen(file_path,'rb');
% FileID = fopen(input,'rb');
framesize = width*height*2;
fseek(FileID, 0, 'eof');
fsize = ftell(FileID);
frameNum = fsize/framesize;
fseek(FileID, 0, 'bof');
for frameID = 1:frameNum
    ReadRawImage = fread(FileID, width*height, 'uint16');
    RawImage = reshape(ReadRawImage,width,height);
    RawImage = RawImage';
    RawImage = RawImage - blc_mat;
    RawImage = uint8(RawImage/16);
    demosaic_raw = demosaic(RawImage,bayerpattern);
    demosaic_raw = im2double(demosaic_raw);
    hist_raw = imadjust(demosaic_raw,[0 0 0;1 1 1],[],0.6);
%     imwrite(hist_raw,num2str(frameID),'jpg');
    imwrite(hist_raw,strcat(num2str(frameID),filename,'.jpg')); 
end
fclose(FileID);
% end