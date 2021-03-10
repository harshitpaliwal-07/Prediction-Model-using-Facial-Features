clc;clear;close all;warning off all;
load NeuralNetwork_Training;
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
