clear all; 
close all;

%expects a directory structure [/sub/run] - requires SPM on your path
sub=['HS5'];

%specify runs to include
runs=6;

%choose slice - set for transverse slice
slice=20;

%loop through runs collecting all files prefixed with f
for r=1:runs
a{r}=spm_select('FPList',[pwd,'/',sub,'/run',num2str(r)],['^f.*\.nii$']);
end

 % create the video writer with 30 fps
 writerObj = VideoWriter([sub,'.avi']);
 writerObj.FrameRate = 30;
 % open the video writer
 open(writerObj);
 
 %intialise counter
 c=0;
 
 %open .nii files one by one
 for r=1:runs
    for i=1:size(a{r},1)
     c=c+1;
    hdr=spm_vol(a{r}(i,:));
    data=spm_read_vols(hdr);
    images{c}=data(:,:,slice);
    clear hdr data
    end
 end
 
clear c

 % write the frames to the video
 for u=1:length(images)
     % convert the image to a frame
     frame = imagesc(images{u});

    %write video - scaling intensity to [0 1]
     writeVideo(writerObj, frame.CData./max(max(frame.CData)));
     
 end
 
 % close the writer object
 close(writerObj);
 
 
