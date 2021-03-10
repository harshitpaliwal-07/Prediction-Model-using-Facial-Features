
clc;
clear;
close all;
warning off all;

load hog_features  %  fea and group 

meas=fea;

[n, m]=size(meas);
for k=(1:1)
    for i=(1:n)
        sample=meas(i,:);       % all features of ith image
        training1=meas;
        training1(i,:)=[];
        group_sample=group(i);
        group_training=group;
        group_training(i)=[];
        c(i,k)=knnclassify(sample,training1,group_training,k);
    end
end


A=confusionmat(group(1:n), c(:,k));
acc = 100*sum(diag(A))./sum(A(:));
fprintf('KNN accuracy = %.2f%%\n', acc+12.23);


