clc;clear;warning off all;close all;

load haar_features;

class = zeros(3,numel(group));      % create 3x212 matrix

for i =1:numel(unique(group))       % 1 to 3
    class(i,:) = group == i;    
end

class_t = class';

save haar_neural_features class_t fea group


% load haar_features;
%   t = treefit(fea,group');
% %   treedisp(t,'names',{'SL' 'SW' 'PL' 'PW'});
% 
% treedisp(t)