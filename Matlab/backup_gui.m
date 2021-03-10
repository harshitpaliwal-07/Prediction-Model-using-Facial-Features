function varargout = final_gui(varargin)
% FINAL_GUI MATLAB code for final_gui.fig
%      FINAL_GUI, by itself, creates a new FINAL_GUI or raises the existing
%      singleton*.
%
%      H = FINAL_GUI returns the handle to a new FINAL_GUI or the handle to
%      the existing singleton*.
%
%      FINAL_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL_GUI.M with the given input arguments.
%
%      FINAL_GUI('Property','Value',...) creates a new FINAL_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before final_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to final_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help final_gui

% Last Modified by GUIDE v2.5 08-May-2015 01:00:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @final_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @final_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before final_gui is made visible.
function final_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to final_gui (see VARARGIN)

% Choose default command line output for final_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes final_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


%% --- Outputs from this function are returned to the command line.
function varargout = final_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imaqreset
vid=videoinput('winvideo',1,'MJPG_1280x720');
vid.ReturnedColorspace = 'rgb';
vid.framespertrigger=1;
vid.triggerrepeat=inf;
preview(vid)

save work

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load work
im=getsnapshot(vid);
closepreview(vid)
axes(handles.axes1)
imshow(im)
save work


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% im=imresize(im,[512 512]);
% bbox = step(faceDetector, im);
% face=imcrop(im,bbox);
% axes(handles.axes1)
% imshow(face)


load work
I=imread(im);


f=dir('C:\Users\KkD\Documents\MATLAB\age_classification\last_stand\added_svm_pca\SubFunctions\*.xml');

for i=1:length(f)
    filename=f(i).name;
    ConvHaar_casade_OpenCV(filename(1:end-4));
end

% HaarCascade=Get_Haar_Casade('haarcascade_frontalface_alt.m');
Objects=ObjectDetection(I,'haarcascade_frontalface_alt.mat');
Num_rows=size(Objects);

if Num_rows>1
    final_Object=sum(Objects)/(Num_rows(1));
else final_Object=Objects;
end

ShowDetectionResult(I,final_Object);

figure
im=imcrop(I,final_Object);
%  im=imresize(I,[256 256]);
imshow(im);

%% NOSE DETECTION:
%To detect Nose
NoseDetect = vision.CascadeObjectDetector('Nose','MergeThreshold',10);
BB1=step(NoseDetect,im);
% figure,
% imshow(im); hold on
for i = 1:size(BB1,1)
    rectangle('Position',BB1(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
end
title('Nose Detection');
hold on;

%% Eye Pair DETECTION:
%To detect Eye Pair
EyePairDetect = vision.CascadeObjectDetector('EyePairBig','MergeThreshold',16);

BB2=step(EyePairDetect,im);
r=size(BB2);
if(r(1,1)==0)
    EyePairDetect = vision.CascadeObjectDetector('EyePairSmall','MergeThreshold',1);
end
BB2=step(EyePairDetect,im);

% figure,
% imshow(im); hold on

for i = 1:size(BB2,1)
    rectangle('Position',BB2(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
end
title('Eye pair Detection');
hold on;


%% Mouth DETECTION:a
%To detect Mouth
MouthDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',20);
BB3=step(MouthDetect,im);
% figure,
% imshow(im); hold on
for i = 1:size(BB3,1)
    rectangle('Position',BB3(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
end
title('Mouth Detection');
hold on;



%% Face profile DETECTION:
%To detect Mouth
FaceProfileDetect = vision.CascadeObjectDetector('ProfileFace','MergeThreshold',1);
BB4=step(FaceProfileDetect,im);
% figure,
% imshow(im); hold on
for i = 1:size(BB4,1)
    rectangle('Position',BB4(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
end
title('FaceProfile Detection');
hold on;


im2=rgb2gray(im);
imshow(im2);
figure;

im2 = imadjust(im2,stretchlim(im2),[]);
imshow(im2);
figure;

im2=histeq(im2);
imshow(im2);

%im2=medfilt2(im2,[3 3]);
im2 = filter2(fspecial('average',3),im2)/255;
% figure, imshow(im2);

[Gmag, Gdir]=imgradient(im2,'sobel');
figure, imshow(Gmag)

im3=im2bw(Gmag,graythresh(Gmag));
figure,imshow(im3);


% se = strel('square',2);        %structural element used in morphological operation
% im3 = imdilate(im3,se);          % imdilate will shrink the image
% imshow(im3);
% hold on;
% i4 = imfill(im3,'holes');

im2A=imcrop(Gmag,[BB2(1,1) final_Object(1,2) BB2(1,3) -final_Object(1,2)+BB2(1,2)]);
im2B=imcrop(Gmag,[BB2(1,1) BB1(1,2) -BB2(1,1)+BB1(1,1) BB1(1,4)]);
im2C=imcrop(Gmag,[BB1(1,1)+BB1(1,3) BB1(1,2) -BB2(1,1)+BB1(1,1) BB1(1,4)]);
im2D=imcrop(Gmag,[final_Object(1,1)-(-BB2(1,1)+final_Object(1,1))*2/3 BB2(1,2) (BB2(1,1)-final_Object(1,1))*2/3 BB2(1,4)]);
im2E=imcrop(Gmag,[BB2(1,1)+BB2(1,3) BB2(1,2) (BB2(1,1)-final_Object(1,1))*2/3 BB2(1,4)]);


im2A=double(im2A);
im2B=double(im2B);
im2C=double(im2C);
im2D=double(im2D);
im2E=double(im2E);
im4=~im3;


figure,imshow(im4);

im3=double(im3);
im3A=imcrop(im3,[BB2(1,1) final_Object(1,2) BB2(1,3) -final_Object(1,2)+BB2(1,2)]);
im3B=imcrop(im3,[BB2(1,1) BB1(1,2) -BB2(1,1)+BB1(1,1) BB1(1,4)]);
im3C=imcrop(im3,[BB1(1,1)+BB1(1,3) BB1(1,2) -BB2(1,1)+BB1(1,1) BB1(1,4)]);
im3D=imcrop(im3,[final_Object(1,1)-(-BB2(1,1)+final_Object(1,1))*2/3 BB2(1,2) (BB2(1,1)-final_Object(1,1))*2/3 BB2(1,4)]);
im3E=imcrop(im3,[BB2(1,1)+BB2(1,3) BB2(1,2) (BB2(1,1)-final_Object(1,1))*2/3 BB2(1,4)]);

%im3_fh=imcrop(im3,[final_Object(1,1:2) final_Object(1,1)-BB2(1,1) BB2(1,2)])

figure
imshow(im3A)
figure
imshow(im3B)
figure
imshow(im3C)
figure
imshow(im3D)
figure
imshow(im3E)


im3A=double(im3A);
im3B=double(im3B);
im3C=double(im3C);
im3D=double(im3D);
im3E=double(im3E);

v1 =[-BB3(1,1)-BB3(1,3)/2+BB2(1,1), -BB3(1,2)-BB3(1,4)+BB2(1,2)];
v3 = [BB3(1,1)+BB3(1,3)/2-BB2(1,1)+BB2(1,3), BB3(1,2)+BB3(1,4)-BB2(1,2)+BB2(1,4)];

u1 = v1 / norm(v1);
u3 = v3 / norm(v3);


W1=(sum(sum(im3A)));
M1=(sum(sum(im2A)));
P1=length(im3A)^2;

W2=(sum(sum(im3B)));
M2=(sum(sum(im2B)));
P2=length(im3B)^2;

W3=(sum(sum(im3C)));
M3=(sum(sum(im2C)));
P3=length(im3C)^2;

W4=(sum(sum(im3D)));
M4=(sum(sum(im2D)));
P4=length(im3D)^2;

W5=(sum(sum(im3E)));
M5=(sum(sum(im2E)));
P5=length(im3E)^2;

W=W1+W2+W3+W4+W5;
P=P1+P2+P3+P4+P5;
M=M1+M2+M3+M4+M5;

R1=BB2(3);
R2=pdist([BB2(1:2);BB3(1:2)],'euclidean');
R3=pdist([BB2(1:2);BB1(1:2)],'euclidean');
R4=pdist([BB2(1:2);final_Object(1,1)+final_Object(1,4) final_Object(1,1)+(final_Object(1,3))/2],'euclidean');
F1=R1/R3;
F2=R1/R2;
F3=R3/R4;
F4=R3/R2;

F5= (W)/(P);
F6=(M)/(255*abs(W));
F7=M/(255*P);
F8 = acos(dot(u1, u3)) ;

save work

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load work
load haar_features   

train_set_1=fea(:,1:4);
test_set_1=[F1 F2 F3 F4];

class=group';

result=knnclassify(test_set_1,train_set_1,class,1,'cosine','nearest')

if result == 2
    msgbox('Child')
else
    
    train_set_2=fea(:,5:8);
    test_set_2=[F5 F6 F7 F8];
    class=group';
    
        result = knnclassify(test_set_2,train_set_2,class,1,'cosine','nearest')
    
   
    if result ==1
        msgbox('Adult')
    elseif result == 3
        msgbox('senior')
    end
end


delete work.mat
