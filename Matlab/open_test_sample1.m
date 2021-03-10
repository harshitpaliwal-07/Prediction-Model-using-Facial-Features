function [test_feat] = open_test_sample1(filename)


faceDetector = vision.CascadeObjectDetector();

im=imread(filename);
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
    face=imresize(face,[50 50]);
    [test_feat] = hog_feature_vector(face);
    
end