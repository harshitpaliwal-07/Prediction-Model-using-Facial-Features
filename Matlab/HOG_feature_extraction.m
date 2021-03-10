clc;
clear;
close all;
warning off all;
fea=[];
group=[];

folder=dir('C:\Users\kukre\Desktop\I.T. Guy\Major Project\Major2\Training_database');
%%
count=0;
%%
faceDetector = vision.CascadeObjectDetector();  % viola jone algorithm 

for mn=3:length(folder)    % mn:3:5
    count=count+1;
    address=strcat('C:\Users\kukre\Desktop\I.T. Guy\Major Project\Major2\Training_database\',folder(mn).name,'\*.png');
    address1=strcat('C:\Users\kukre\Desktop\I.T. Guy\Major Project\Major2\Training_database\',folder(mn).name,'\*.jpg');
    folder(mn).name
    files=dir(address);
    files=[files; dir(address1)];
    num=numel(files);
%     address=strcat('C:\Users\kukre\Desktop\I.T. Guy\Major Project\Major2\Training_database\',folder(mn).name);
%     folder(mn).name     
%     files=dir(address);
%     num=numel(files);  % no of file in mn=3,4 and 5
%     disp(count); % display count value in command window         
    
    for i=1:num
        
        files(i).name 
        
        str=strcat('C:\Users\kukre\Desktop\I.T. Guy\Major Project\Major2\Training_database\',folder(mn).name,'\',files(i).name);
        im=imread(str);
        imshow(im)
        pause(.1)
        im=imresize(im,[512 512]);
        imshow(im)
        pause(.1)
        bbox = step(faceDetector, im);  % 4 point x,y,w,h
        if numel(bbox)== 4
            face=imcrop(im,bbox);
            imshow(face)
        pause(.1)
            face=imresize(face,[50 50]);
            imshow(face)
           figure
            [feature] = hog_feature_vector(face);
          
            fea=[fea;feature];
            group=[group; count];
            %             imshow(face)
        else
            disp('Can not detect face')
        end
    end
end
 % save hog_features_final_with_fea group