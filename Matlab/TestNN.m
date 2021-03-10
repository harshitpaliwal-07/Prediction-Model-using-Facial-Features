clc;clear;close all;warning off all;

load vedant; % for hog feature only net tr

% load haar_features; % for wrinkle + geometrical
% fea1=fea(:,3000)
%%
% class = zeros(3,numel(group));      % create 3x212 matrix
% 
% for i =1:numel(unique(group))
%     class(i,:) = group == i;    
% end
% 
% class_t = class';
%%

[a, b]= uigetfile('*.*');

filename = fullfile(b,a);

[features] = open_test_sample(filename);   %test feature 
test_n = net(features');
test_index = vec2ind(test_n);
if test_index==1
    msgbox('Adult');
   
elseif test_index==2
    msgbox('Child');
  
elseif test_index==3
    msgbox('Old');
end
