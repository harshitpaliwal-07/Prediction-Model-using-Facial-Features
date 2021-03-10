clc;clear;close all;warning off all;

load hog_features_final_with_shiva; % for hog feature only 

% load haar_features; % for wrinkle + geometrical
% fea1=fea(:,3000)
%%
class = zeros(3,numel(group));      % create 3x212 matrix

for i =1:numel(unique(group))
    class(i,:) = group == i;    
end

class_t = class';
%%
% 
% [a, b]= uigetfile('*.*');
% 
% filename = fullfile(b,a);
% 
% [features] = open_test_sample(filename);   %test feature 

x = fea';
t = class_t';
    
% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.

% Create a Pattern Recognition Network
hiddenLayerSize = 10;
net = patternnet(hiddenLayerSize);

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y);
tind = vec2ind(t);
yind = vec2ind(y);
percentErrors = sum(tind ~= yind)/numel(tind);

% View the Network
view(net);
% test the sample
% test_n = net(features');
% test_index = vec2ind(test_n);
% if test_index==1
%     msgbox('Adult');
%    
% elseif test_index==2
%     msgbox('Child');
%   
% elseif test_index==3
%     msgbox('Old');
% end


% Plots
% Uncomment these lines to enable various plots.
% figure, plotperform(tr)
% figure, plottrainstate(tr)
% figure, ploterrhist(e)
 figure, plotconfusion(t,y)
figure, plotroc(t,y)

% save vedant net