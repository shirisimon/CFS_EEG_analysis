 
%% compute_allMuSuppInd
clear all
% path = ['C:\Research\Study 3 - MNS response to invisible actions\EEG\Results\' ... 
%     'ERSPs\versions_1014\single_subjects_elcs_ERSPs_cleanWithCOelcs\'];
path = ['C:\study3_MNS and conscious perception\Results\ERSPs\current\fix_baseline_ERD\'];
subject = {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' '336' ...
           '340' '342' '344' '345' '346' '347' '348' '350'};
% subject = {'355' '356' '357' '358' '359'};
idx = 0;
condsNum = 2;
for s = 1:size(subject,2)
    load([path, subject{s} '_ERSP-elcs.mat']);
    for e = [1 3 2 4];  % elc num.
        %% extract bin
        onset  = find(timesout >= -1000, 1 );
        offset = find(timesout >= 0, 1); %max(timesout), 1 );
        %% extract freqs
        alpha = [find(freqsout >= 8, 1), find(freqsout <= 13, 1, 'last')];
        low_alpha = [find(freqsout >= 8, 1), find(freqsout <= 10, 1, 'last')];
        high_alpha = [find(freqsout >= 11, 1), find(freqsout <= 13, 1, 'last')];
        beta = [find(freqsout >= 15, 1), find(freqsout <= 25, 1, 'last')];
        for c = [3 4];      % insert contrast 1,2 (actions) / 3,4 (control-bird) / 4,6 (non-masked action vs. bird)
            idx = idx+1;
            try
                adata = data(c).elc{e}.ERSP(alpha(1):alpha(2),onset:offset);
                bdata = data(c).elc{e}.ERSP(beta(1):beta(2),onset:offset);
                low_adata =  data(c).elc{e}.ERSP(low_alpha(1):low_alpha(2),onset:offset);
                high_adata =  data(c).elc{e}.ERSP(high_alpha(1):high_alpha(2),onset:offset);
            catch err
                adata = [];
                bdata = [];
            end    
            alpha_results(s,idx) = mean(mean(adata));
            beta_results(s,idx)  = mean(mean(bdata));
            low_alpha_results(s,idx) = mean(mean(low_adata));
            high_alpha_results(s,idx) = mean(mean(high_adata));
        end
    end
    idx = 0;
end

%% COPY EACH TABLE TO EXCLE SHEET ACCORDING TO FREQUENCY BAND
