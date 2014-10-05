 
%% compute_allMuSuppInd
clear all
% path = ['F:\Study 3 - MNS response to invisible actions\EEG\Results\Step 2 - ERSPs\' ...
%     'single subjects ERSPs - clean-COelcs_rmICstrict\with_erspboot\'];
path = ['C:\s3_2ndpool data backup\results\ctrl\'];
%subject = {'351' '352' '353'};
subject = {'324' '326' '328' '329' '331' '332' '333' '334' '335' '336' '337'...
               '340' '342' '344' '345' '346' '347' '348' '350'};
idx = 0;
for s = 1:size(subject,2)
    load([path subject{s} '_ERSP.mat']);
    for e = [1 3 2 4];  % elc num.
        %% extract bin
        onset  = find(timesout >= 500, 1 );
        offset = find(timesout >= max(timesout), 1 );
        %% extract freqs
        alpha = [find(freqsout >= 8, 1), find(freqsout <= 13, 1, 'last')];
        beta = [find(freqsout >= 15, 1), find(freqsout <= 25, 1, 'last')];
        for c = 1:2;      % insert contrast 1,2 (actions) / 3,4 (control-bird) / 4,6 (non-masked action vs. bird)
            idx = idx+1;
            try
                adata = data(c).elc{e}.ERSP(alpha(1):alpha(2),onset:offset);
                bdata = data(c).elc{e}.ERSP(beta(1):beta(2),onset:offset);
            catch err
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
