%% plotElcCoh_studyBased
clear all
close all
filename = '19subjects_ICA_rmICstrict.study';
filepath = 'C:\Research\Study 3 - MNS response to invisible actions\EEG\Data\2nd_pool_data_2ndPiplinePreProcessing';
[STUDY, ALLEEG] = pop_loadstudy('filename', filename, 'filepath', filepath);

% params:
type = 'phasecoher'; % coher\ phasecoher\ amp
subitc = 'off';
baseline = NaN;
alpha = .01;
cycles = [3 0.5]; % wavelet cycles
freqscale = 'log';
frqlim = [3 40]; % calculation frequency limits in Hz
tmlims = [-1.5 2]; % [min max] times in ms for window
cond = 4; % memorize only
chan1 = 50;
chan2 = 13; %27

for c = 1:2
    for s = 1:length(STUDY.subject);
        elc1 = chan1; %STUDY.changrp(chan1).channels{1};
        elc2 = chan2; %STUDY.changrp(chan2).channels{1};
        if c == 1;
            EEG = pop_loadset('filename', ALLEEG(s*2-1).filename, 'filepath', ALLEEG(s*2-1).filepath); % act4
        else EEG = pop_loadset('filename', ALLEEG(s*2).filename, 'filepath', ALLEEG(s*2).filepath); %act1
        end
        EEG = pop_epoch( EEG, {}, tmlims, 'epochinfo', 'yes');
        
%         [coh(:,:,p,c),mcoh,times,freqs,~,cohang(:,:,p,c)] = ...
%             newcrossf(EEG.data(elc1,:,:),  EEG.data(elc2,:,:), ...
%             EEG.pnts, [EEG.xmin*1000 EEG.xmax*1000], EEG.srate, cycles, ...
%             'alpha', alpha,'winsize',EEG.srate,'newfig','off', ...
%             'type',type,'freqs',frqlim,'freqscale' ,freqscale, ...
%             'savecoher',0 , 'plotamp' ,'off','plotphase' ,'off', ...
%             'subitc', subitc, 'baseline', baseline);
    

    data1 = reshape(EEG.data(elc1,:,:), 1, size(EEG.data,2)*size(EEG.data,3));
    data2 = reshape(EEG.data(elc2,:,:), 1, size(EEG.data,2)*size(EEG.data,3));
    [coh(:,:,s,c),mcoh(:,:,s,c),times,freqs,cohboot(:,:,s,c), cohang(:,:,s,c)] = ...] = ... %
            newcrossf(data1,  data2, ...
            EEG.pnts, [EEG.xmin*1000 EEG.xmax*1000], EEG.srate, cycles, ...
            'alpha', alpha, 'savecoher',0 , 'freqs', frqlim, ... % 'plotamp' ,'off','plotphase' ,'off', ...
            'subitc', subitc, 'baseline', baseline,   'padratio', 16, ...
            'angleunit', 'deg');
        path = 'C:\Research\Study 3 - MNS response to invisible actions\EEG\Results\Coherence\';
        if c==1; cond = 'full-rec'; else cond = 'non-rec'; end
        saveas(gcf, [path, EEG.subject '_' cond '_'  ALLEEG(c).chanlocs(chan1).labels '-' ...
            ALLEEG(c).chanlocs(chan2).labels], 'jpg');
        close figure 1
    end
end

%% ttest
for f = 1:size(coh,1)
    for t = 1:size(coh,2)
        [~,ttest2_pval(f,t)] = ttest2(coh(f,t,:,1), coh(f,t,:,2),0.05, 'right');
    end
end
save([path, 'allsub_coh_data_'  ALLEEG(c).chanlocs(chan1).labels '-' ...
            ALLEEG(c).chanlocs(chan2).labels '.mat'], 'coh', 'mcoh', 'times', 'freqs', 'cohboot',  'ttest2_pval');

%% plots: 
% cond 1:
figure;
imagesclogy(times,freqs,mean(coh(:,:,:,1),3));
set(gca,'ydir','norm');hold on;
plot([0 0],[get(gca,'ylim')],'k-');
cbar;
saveas(gcf, [path, 'allsub_full-rec_'  ALLEEG(c).chanlocs(chan1).labels '-' ...
            ALLEEG(c).chanlocs(chan2).labels], 'jpg');
% cond 2:
figure;
imagesclogy(times,freqs,mean(coh(:,:,:,2),3));
set(gca,'ydir','norm');hold on;
plot([0 0],[get(gca,'ylim')],'k-');
cbar;
saveas(gcf, [path, 'allsub_no-rec_'  ALLEEG(c).chanlocs(chan1).labels '-' ...
            ALLEEG(c).chanlocs(chan2).labels], 'jpg');
% pval
figure; 
imagesclogy(times,freqs,ttest2_pval);
set(gca,'ydir','norm');hold on;
plot([0 0],[get(gca,'ylim')],'k-');
cbar;
saveas(gcf, [path, 'allsub_ttest-pval_'  ALLEEG(c).chanlocs(chan1).labels '-' ...
            ALLEEG(c).chanlocs(chan2).labels], 'jpg');
