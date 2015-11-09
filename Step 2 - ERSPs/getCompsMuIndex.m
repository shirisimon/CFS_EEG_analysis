
%% compute_allMuSuppInd
clear all
close all

path =  ['C:\Research\Study 3 - MNS response to invisible actions\EEG\Results\ERSPs\' ...
    '3levels_exp\'];
subject = {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' '336'...
    '340' '342' '344' '345' '346' '347' '348' '350'};
comps =  {'left_mu', 'right_mu', 'left_alpha', 'right_alpha'};

condsNum = 3; 
idx = 0;
for s = 1:size(subject,2)
    load([path subject{s} '_ERSP_cmps.mat']);
    %% extract bin
    onset  = find(timesout >= 500, 1 );
    offset = find(timesout >= max(timesout), 1 );
    %% extract freqs
    alpha = [find(freqsout >= 8, 1), find(freqsout <= 13, 1, 'last')];
    beta = [find(freqsout >= 15, 1), find(freqsout <= 25, 1, 'last')];
    
    %%
    for fc = 1:size(comps,2)
        for c = 1:condsNum;      % insert contrast 1,2 (actions) / 3,4 (control-bird) / 4,6 (non-masked action vs. bird)
            idx = idx+1;
            data(c).avg_comp{fc}.label = comps{fc};
            try
                data(c).avg_comp{fc}.ERSP = data(c).comp{fc}.ERSP; % mean(ersp{c,fc},3);
                adata = data(c).avg_comp{fc}.ERSP(alpha(1):alpha(2),onset:offset);
                bdata = data(c).avg_comp{fc}.ERSP(beta(1):beta(2),onset:offset);
            catch err
                data(c).avg_comp{fc}.ERSP = [];
                adata = [];
                bdata = [];
            end
            alpha_results(s,idx) = mean(mean(adata));
            beta_results(s,idx)  = mean(mean(bdata));
        end
    end
    idx = 0;
end


%% COPY EACH TABLE TO EXCLE SHEET ACCORDING TO FREQUENCY BAND
    %% extruct avg ICs results (when subject is assigned with more than
    %% 1 component to a functional component :
%     counts = zeros(1,size(comps,2));
%     for c = 1:condsNum; % num of conditions exist
%         %for fc = 1:size(comps,2)
%         for ic = 1:size(comps,2)
%             ic_label = data(1).comp{ic}.label;
%             for fc = 1:size(comps,2)
%                 if strcmp(ic_label,comps{fc})
%                     counts(fc) = counts(fc)+1;
%                     ersp{c,fc}(:,:,counts(fc)) = data(c).comp{ic}.ERSP;
%                     break
%                 end
%             end
%         end
%         counts = zeros(1,size(comps,2));
%         %end
%     end