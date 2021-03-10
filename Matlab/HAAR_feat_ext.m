clc;
clear;
close all;
warning off all;
%% variable declarations
fea=[]; % features
group=[];
%% folder path extraction
% f=dir('C:\Users\kukre\Desktop\Major2\*.xml');  % get xml file
folder=dir('C:\Users\kukre\Desktop\Major2\Training_database');
count=0;
file_count=0;
FDetect = vision.CascadeObjectDetector;     % creates a System object, detector, that detects objects using 
% the Viola-Jones algorithm. 
% By default, the detector is configured to detect faces.
% pass xml file to ConvHaar_casade_OpenCV() function which converts haarcascade_frontalface_alt.xml 
% to .m -> matlab file and create a .mat file
% haarcascade_frontalface_alt.xml  
% haarcascade_frontalface_alt.m
% haarcascade_frontalface_alt.mat
% for fi=1:length(f)
%     filename=f(fi).name;
%     ConvHaar_casade_OpenCV(filename(1:end-4));
% end
% 
% This function reads a Matlab file with a struct containing
% the OpenCV classifier data of an openCV XML file.
% It also changes the structure a little bit, and add missing fields
% HaarCascade=Get_Haar_Casade('haarcascade_frontalface_alt.m');
% get inside the training folder

%% Feature extraction of all the files

for mn=3:length(folder)
    count=count+1;
    address=strcat('C:\Users\kukre\Desktop\Major2\Training_database\',folder(mn).name,'\*.png');
    address1=strcat('C:\Users\kukre\Desktop\Major2\Training_database\',folder(mn).name,'\*.jpg');
    folder(mn).name
    files=dir(address);
    img=[files; dir(address1)];
    num=numel(img);
    
    for i=1:num
        count
        i;
        file_count=file_count+1;
        str=strcat('C:\Users\kukre\Desktop\Major2\Training_database\',folder(mn).name,'\',files(i).name);
        I=imread(str);
        imshow(I)
        figure
        
        % detect objects in the image using haar like features
        
        Objects=ObjectDetection(I,'haarcascade_frontalface_alt.mat');   % will get x,y,w,h
        
        Num_rows=size(Objects);
        if Num_rows>1                                       % check for valid objects
           final_Object=sum(Objects)/(Num_rows(1));        % get an average value
        else final_Object=Objects;
        end
        %ShowDetectionResult(I,final_Object);
        
        %figure
        im=imcrop(I,final_Object);
        imshow(im)
        pause(.3)
        % comment
        %% section 
        
        
          im=imresize(I,[256 256]);
        imshow(im);

        figure
        
        
        %% NOSE DETECTION:
        %To detect Nose
        NoseDetect = vision.CascadeObjectDetector('Nose','MergeThreshold',10);
        BB1=step(NoseDetect,im);        % get bounding box
        
        Num_rows=size(BB1);
        if Num_rows>1                   % check for valid data
            BB1=sum(BB1)/(Num_rows(1));
        else BB1=BB1;
        end
        
        
        figure,
        imshow(im); hold on
        for i = 1:size(BB1,1)
            rectangle('Position',BB1(i,:),'LineWidth',2,'LineStyle','-','EdgeColor','b');
        end
        title('Nose');
        hold on;
        
        
        
       %% Eye Pair DETECTION:
        %To detect Eye Pair
        EyePairDetect = vision.CascadeObjectDetector('EyePairBig','MergeThreshold',16);
        BB2=step(EyePairDetect,im);       % get bounding box
        r=size(BB2);
              
        
        if(r(1,1)==0)
            EyePairDetect = vision.CascadeObjectDetector('EyePairSmall','MergeThreshold',2);
        end
        
        BB2=step(EyePairDetect,im);
        Num_rows=size(BB2);
        
        if Num_rows>1                       % check for valid data
            BB2=sum(BB2)/(Num_rows(1));
        else BB2=BB2;
        end
        
        
        figure,
        imshow(im); hold on
        for i = 1:size(BB2,1)
            rectangle('Position',BB2(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','g');
        end
        title('Eye pair Detection');
        hold on;
        
        %% Mouth DETECTION:
        %To detect Mouth
        MouthDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',20);
        BB3=step(MouthDetect,im);
        Num_rows=size(BB3);
        
        if Num_rows>1                       % check for valid data
            BB1=sum(BB3)/(Num_rows(1));
        else BB3=BB3;
        end
        
        figure,
        imshow(im); hold on
        for i = 1:size(BB3,1)
            rectangle('Position',BB3(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
        end
        title('Mouth Detection');
        hold on;
        
        %% Face Profile DETECTION:
        %To detect Mouth using weak classifiers
        
        FaceProfileDetect = vision.CascadeObjectDetector('ProfileFace','MergeThreshold',1);
        BB4=step(FaceProfileDetect,im);
        
        
        figure,
        imshow(im); hold on
        for i = 1:size(BB4,1)
            rectangle('Position',BB4(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
        end
        title('FaceProfile Detection');
        hold on;
        
        
        % BB1 = nose, BB2 = eyepair, BB3 = mouth BB4 = Face Profile
        
        
        flag=0;
        BB_size=[size(BB1);size(BB2);size(BB3)];    % collect the bounding boxes in single matrix
        
        
        for k=1:3
            if(BB_size(k,1)==0)      % str has filemane along with path
                flag=1;              % if none of the objects i.e. nose
                delete(str);         % eyepair, mouth is detected then
            end                      % delete the image file from training folder
        end
        
        
        if flag==0
  
            %% Preprocessing of image            
            
            
            [r, c, p]=size(im);      % checking weather image is coloured or not
            if p==3                  % if coloured then convert into gray
                im2 = rgb2gray(im);  % convert to grayscale
            else
                delete(str);         % delete the image file from training folder
            end
            
            
            %
            imshow(im2)  % gray image output display
            figure
            im2 = imadjust(im2,stretchlim(im2),[]);     % Adjust the contrast of the image, specifying contrast limits.
            imshow(im2)
            figure
            im2=histeq(im2);                            % Enhance contrast using histogram equalization
            imshow(im2)
            figure
            %im2=medfilt2(im2,[3 3]);
            im2 = filter2(fspecial('average',3),im2)/255;  % 2-D digital filter using predefined 2-D averaging filter
            figure, imshow(im2)
            
            
            
            [Gmag, Gdir]=imgradient(im2,'sobel');          % Gradient magnitude and direction of an image using Sobel gradient operator
            %im3= edge(im2,'Sobel',0.02);
            figure, imshow(Gmag)
            im3=im2bw(Gmag,graythresh(Gmag));               % convert to black and white
            figure,imshow(im3); % ?
            pause(.20)
            
            % crop the gradient image
            % crop to get forehead region
%             BB = [ x, y, w, h]

            % BB1 = nose, BB2 = eyepair, BB3 = mouth
            
            
            % im2 = grayscale image
            % im3 = black and white image
%             % Gmag is grayscale image
%             
%             
%             imfull = im;
           
            
            % processing on gray scale image
            
            im2A=imcrop(Gmag,[BB2(1,1) final_Object(1,2) BB2(1,3) -final_Object(1,2)/2+BB2(1,2)]);    % forehead
            %            figure(1),imshow(im2A)
            %            hold on
            %
            % crop to get left eyelid region
            im2B=imcrop(Gmag,[BB2(1,1) BB1(1,2) -BB2(1,1)+BB1(1,1) BB2(1,4)/2]);          % left eyebrow
            %             figure(2),imshow(im2B)
            %             hold on
            
            % crop to get right eyelid region
            im2C=imcrop(Gmag,[BB1(1,1)+BB1(1,3) BB1(1,2) -BB2(1,1)+BB1(1,1) BB2(1,4)/2]); % right eyebrow
            %             figure(3),imshow(im2C)
            %             hold on
            
            % crop to get left eye corner region
            im2D=imcrop(Gmag,[final_Object(1,1)-(-BB2(1,1)+final_Object(1,1))*2/3 BB2(1,2) (BB2(1,1)-final_Object(1,1))*2/3 BB2(1,4)]);   % left cheek
            %             figure(4),imshow(im2D)
            %             hold on
            
            % crop to get right eye corner region
            im2E=imcrop(Gmag,[BB2(1,1)+BB2(1,3) BB2(1,2) (BB2(1,1)-final_Object(1,1))*2/3 BB2(1,4)]);      % right cheek
            %             figure(5),imshow(im2E)
            %             hold on
            
            % convert to double precision
            im2A=double(im2A);
            im2B=double(im2B);
            im2C=double(im2C);
            im2D=double(im2D);
            im2E=double(im2E);
%             im4=~im3;
            
            % figure,imshow(im4);
            
            % crop the black and white image
            
            % do the same as above but on black and white processed image
            
            
            % processing on Black and white image
            
            im3=double(im3);
            
            im3A=imcrop(im3,[BB2(1,1) final_Object(1,2) BB2(1,3) -final_Object(1,2)+BB2(1,2)]);
            im3B=imcrop(im3,[BB2(1,1) BB1(1,2) -BB2(1,1)+BB1(1,1) BB2(1,4)/2]);
            im3C=imcrop(im3,[BB1(1,1)+BB1(1,3) BB1(1,2) -BB2(1,1)+BB1(1,1) BB2(1,4)/2]);
            im3D=imcrop(im3,[final_Object(1,1)-(-BB2(1,1)+final_Object(1,1))*2/3 BB2(1,2) (BB2(1,1)-final_Object(1,1))*2/3 BB2(1,4)]);
            im3E=imcrop(im3,[BB2(1,1)+BB2(1,3) BB2(1,2) (BB2(1,1)-final_Object(1,1))*2/3 BB2(1,4)]);
            
            %im3_fh=imcrop(im3,[final_Object(1,1:2) final_Object(1,1)-BB2(1,1) BB2(1,2)])
            % figure
            % imshow(im3A)
            % figure
            % imshow(im3B)
            % figure
            % imshow(im3C)
            % figure
            % imshow(im3D)
            % figure
            % imshow(im3E)
            
            
            
            % convert to double precision
            im3A=double(im3A);
            im3B=double(im3B);
            im3C=double(im3C);
            im3D=double(im3D);
            im3E=double(im3E);
            
            
            W1=(sum(sum(im3A)));        % is the number of wrinkle pixels in forehead region
            M1=(sum(sum(im2A)));        % the canny edge magnitude of wrinkle pixel
            P1=length(im3A)^2;          % square of the number of pixels
            
            W2=(sum(sum(im3B)));        % sum of pixels in left eyelid region
            M2=(sum(sum(im2B)));
            P2=length(im3B)^2;
            
            W3=(sum(sum(im3C)));        % sum of pixels in right eyelid region
            M3=(sum(sum(im2C)));
            P3=length(im3C)^2;
            
            W4=(sum(sum(im3D)));        % sum of pixels in left eye corner region
            M4=(sum(sum(im2D)));
            P4=length(im3D)^2;
            
            W5=(sum(sum(im3E)));        % sum of pixels in right eye corner region
            M5=(sum(sum(im2E)));
            P5=length(im3E)^2;
            
            W=W1+W2+W3+W4+W5;           % sum of the pixels of the black and white image
            P=P1+P2+P3+P4+P5;           % sum of the square of length of all the detected regions
            M=M1+M2+M3+M4+M5;        % sum of the pixels of the gradient image
            
            % BB = [ x, y, w, h]
            % BB1 = nose, BB2 = eyepair, BB3 = mouth
            
            % get the straight line vector between center of mouth and left
            % eye
            
            v1 = [-BB3(1,1)-BB3(1,3)/2+BB2(1,1), -BB3(1,2)-BB3(1,4)+BB2(1,2)];
            
            % get the straight line vector between center of mouth and
            % right eye
            
            v3 = [BB3(1,1)+BB3(1,3)/2-BB2(1,1)+BB2(1,3), BB3(1,2)+BB3(1,4)-BB2(1,2)+BB2(1,4)];
            
            u1 = v1 / norm(v1);
            u3 = v3 / norm(v3);
            
            
            % Pairwise distance between pairs of objects
            % BB1 = nose, BB2 = eyepair, BB3 = mouth
            
            R1=BB2(3);                                      %  distance between both eyes
            R2=pdist([BB2(1:2);BB3(1:2)],'euclidean');      %  distance between eye pair and mouth
            R3=pdist([BB2(1:2);BB1(1:2)],'euclidean');      %  distance between eye pair and nose
            R4=pdist([BB2(1:2);final_Object(1,1)+final_Object(1,4) final_Object(1,1)+(final_Object(1,3))/2],'euclidean'); %  distance b/w eye pair and chin
            
            F1=R1/R3;  % F1 = (distance from left to right eye ball) / (distance from eye to nose)
            F2=R1/R2;  % F2 = (distance from left to right eye ball) / (distance from eye to lip)
            F3=R3/R4;  % F3 = (distance from eye to nose) / (distance from eye to chin)
            F4=R3/R2;  % F4 = (distance from eye to nose) / (distance from eye to lip)
            
            
            %%
            
%                 WFULL = (sum(sum(imfull)));
%                 MFULL = (sum(sum(imfull)));
%                 PFULL = length(imfull)^2;
%             
            
            %%
            
            F5= (W)/(P);                     % Wrinkle Density
            F6= (M)/(255*abs(W));            % Wrinkle depth
            F7= (M)/(255*P);                 % Average Skin Variance
            F8 = acos(dot(u1, u3)) ;         % get the angle by dot product of the two mormalized vectors
            
            final_feature=[F1,F2,F3,F4,F5,F6,F7,F8];
            fea=[fea;final_feature];
            group=[group, count];
          
      %  else
          %  group=[group];
        end
    end
end

% save haar_features fea group 

