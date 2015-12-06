
%% getElcsMuLatency
% Alpha\Beta
% Central\Occipital
% Right\Left

clear all; close all; clc;
% path = ['C:\Research\Study 3 - MNS response to invisible actions\EEG\Results\' ...
%     'ERSPs\versions_1014\single_subjects_elcs_ERSPs_cleanWithCOelcs\'];
path = ['C:\study3_MNS and conscious perception\Results\ERSPs\current\cfs_baseline_ERD\'];
subject = {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' '336' ...
    '340' '342' '345' '346' '347' '348'};
% subject = {'355' '356' '357' '358' '359'};
idx = 0;
condsNum = 2;
do_ttest = 1;



for s = 1:size(subject,2)
    load([path, subject{s} '_ERSP-elcs.mat']);
    for e = 1:4;  % elc num. 1-C3, 2-O1, 3-C4, 4-O2
        %% extract bin
        onset  = find(timesout >= -400, 1 );
        offset = find(timesout >= max(timesout), 1 );
        %% extract freqs
        alpha = [find(freqsout >= 8, 1), find(freqsout <= 13, 1, 'last')];
        low_alpha = [find(freqsout >= 8, 1), find(freqsout <= 10, 1, 'last')];
        high_alpha = [find(freqsout >= 11, 1), find(freqsout <= 13, 1, 'last')];
        beta = [find(freqsout >= 15, 1), find(freqsout <= 25, 1, 'last')];
        gamma = [find(freqsout >= 30, 1), find(freqsout <= 40, 1, 'last')];
        for c = 1:6 ;   % insert contrast 1,2 (actions) / 3,4 (control-bird) / 5,6 (non-masked action vs. bird)
            idx = idx+1;
            try
                adata = data(c).elc{e}.ERSP(alpha(1):alpha(2),onset:offset);
                bdata = data(c).elc{e}.ERSP(beta(1):beta(2),onset:offset);
                low_adata =  data(c).elc{e}.ERSP(low_alpha(1):low_alpha(2),onset:offset);
                high_adata =  data(c).elc{e}.ERSP(high_alpha(1):high_alpha(2),onset:offset);
                gdata = data(c).elc{e}.ERSP(gamma(1):gamma(2),onset:offset);
            catch err
                adata = [];
                bdata = [];
            end
            alpha_results(:,s,e,idx) = mean(adata);
            beta_results(:,s,e,idx)  = mean(bdata);
            low_alpha_results(:,s,e,idx) = mean(low_adata);
            high_alpha_results(:,s,e,idx) = mean(high_adata);
            gamma_results(:,s,e,idx) = mean(gdata);
        end
        idx = 0;
    end
    
end

%% LATENCIES STATISTICS
x = timesout(onset:offset);
figure;
for s = 1:size(subject,2)
    y_1 = beta_results(:,s,1,5);   % freq, [trials; subjects; electrodes; condition];
    y_2 = alpha_results(:,s,1,5);
    subplot(2,1,1); plot(x,y_1, 'r'); hold on; ylim([-4 4])
    subplot(2,1,2); plot(x,y_2, 'b'); hold on; ylim([-4 4])      
end

if do_ttest
    y_1 = beta_results(:,:,1,1); % 'r'  % freq, [trials; subjects; electrodes; condition];
    y_2 = alpha_results(:,:,2,1); % 'b'
    % get y_1 sig times
    [~, p1] = ttest(y_1',0,'Tail','left');
    [~, crit_p1, adj_p]=fdr_bh(p1,0.05,'pdep','no');
    time1 = find(p1<crit_p1);
    % get y_2 sig times
    [~, p2] = ttest(y_2',0,'Tail','left');
    [~, crit_p2, adj_p]=fdr_bh(p2,0.05,'pdep','no');
    time2 = find(p2<crit_p2);
    
    %% PLOT LATENCIES
    close all;
    x = timesout(onset:offset);
    y_1 = mean(y_1,2);
    y_2 = mean(y_2,2);
    figure; 
    plot(x,y_1,'r', x(time1), y_1(time1), 'r*'); hold on;
    plot(x,y_2,'b', x(time2), y_2(time2), 'b*');
end

%% preliminary latency results:

% in alpha recognized - o1 > c3
% in alpha recognized - o2 > c4
% in beta recognized - c3 > o1
% in beta recognized - c4 > o2
% in recognized c3 - beta > alpha
% in recognized o1 - alpha > beta
%% in recognized - beta c3 > alpha o1

% in alpha nonmasked - o1 > c3
% in beta nonmasked - o1 > c3
% in nonmasked c3 - alpha > beta
% in nonmasked o1 - alpha > beta
% in nonmasked - alpha o1 > beta c3

%% in alpha o1 - nonmasked > masked






