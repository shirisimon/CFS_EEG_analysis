%% plot_resolts
clear; close all; clc;

load('realacc_all.mat');
acc  = struct2cell(realacc);
acc  = cell2mat(acc); 

aacc = acc(1,:,:,:); % alpha
bacc = acc(2,:,:,:); % beta

ma   = mean(aacc,2);
mb   = mean(bacc,2);

ma = reshape(ma, size(ma,3), size(ma,4));
mb = reshape(mb, size(mb,3), size(mb,4));

%%plot

plot(ma(:,2), 'b'); % occipital channel
hold on;
plot(mb(:,1), 'r'); % central channel
