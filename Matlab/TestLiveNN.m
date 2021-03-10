clc
clear all
close all
warning off all
imaqreset

load ankitNN; 
vid = videoinput('winvideo', 1, 'YUY2_640x480');
src = getselectedsource(vid);
vid.FramesPerTrigger = 1;
preview(vid);
vid.FramesPerTrigger = Inf;
vid.ReturnedColorspace = 'rgb';
im=getsnapshot(vid);
imshow(im)
figure
faceDetector = vision.CascadeObjectDetector();
im=imresize(im,[512 512]);
imshow(im)
figure
bbox = step(faceDetector, im);

if numel(bbox)== 4
    face=imcrop(im,bbox);
    face=imresize(face,[50 50]);
    [features] = hog_feature_vector(face);
     
    test_n = net(features');
test_index = vec2ind(test_n);
if test_index==1
    msgbox('Adult');
   
elseif test_index==2
    msgbox('Child');
  
elseif test_index==3
    msgbox('Old');
end
end
