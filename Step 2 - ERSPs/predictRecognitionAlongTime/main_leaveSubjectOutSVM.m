%% main
clear all; close all; clc;

% params
do_shuffle = 0;

params.factor = 1;
% params.c = 0;
% params.g = 0;

[results, bins] = extractSubjectBinsEstimate();
bins_center = (bins(:,1)+bins(:,2)) ./ 2;

for b = 1:size(results.alpha,5)
    for e = 1:size(results.alpha,3)
        for s = 1:size(results.alpha,2)
            dataR.alpha(s)  = results.alpha(:,s,e,1,b);
            dataNR.alpha(s) = results.alpha(:,s,e,2,b);
            dataR.beta(s)   = results.beta(:,s,e,1,b);
            dataNR.beta(s)  = results.beta(:,s,e,2,b);
        end
        realacc.alpha(b,e) = runSVM(dataR.alpha', dataNR.alpha', params, [], 0); 
        realacc.beta(b,e)  = runSVM(dataR.beta', dataNR.beta', params, [], 0);
    end
end

occipital = mean([realacc.alpha(:,2), realacc.alpha(:,4)],2);
central = mean([realacc.beta(:,1), realacc.alpha(:,3)],2);
plot(bins_center, occipital, 'b'); hold on; 
plot(bins_center, realacc.beta(:,1), 'r')


