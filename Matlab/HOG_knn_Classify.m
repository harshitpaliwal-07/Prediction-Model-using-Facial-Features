clc;
clear ;
close all;
warning off all;

load hog_features_final_with_prateek   % fea , group

faceDetector = vision.CascadeObjectDetector();
[a, b]=uigetfile('*.*');
b=[b, a];
im=imread(b)
figure;
imshow(im);

im=imresize(im,[512 512]);
bbox = step(faceDetector, im);
 Num_rows=size(bbox);
        if Num_rows>1                                       % check for valid objects
           final_Object=sum(bbox)/(Num_rows(1));        % get an average value
        else final_Object=bbox;
        end

if numel(final_Object)== 4
    face=imcrop(im,final_Object);
    imshow(face)
    pause(.5)
    face=imresize(face,[50 50]);
    imshow(face)
    pause(.5)
    [test_feat] = hog_feature_vector(face);
    
    c=knnclassify(test_feat,fea,group);
    
    if c==1
        msgbox('Adult')
    end
    
    if c==2
        msgbox ('Child')
    end
    
    if c==3
        msgbox('Senior')
    end
    
end
