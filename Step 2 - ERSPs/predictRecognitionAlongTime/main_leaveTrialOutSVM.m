%% main_leaveTrialOutSVM
clear all; close all; clc;

f = fopen('last_job.txt', 'w');
subjects   = {'325' '326' '328' '329' '331' '332' '333' '334' '335' '336' ...
              '340' '342' '345' '346' '347' '348'};
input_name = {'ActRec', '_0.5-40flt_M1M2ref_evtEditedv3_allEpochs_manRej'};
input_path = {['C:\study3_MNS and conscious perception\data\' ...
               '2nd_pool_data_1stPiplinePreProcessing\'], '\new epochs\equalTrlsNum'};

SVMparams.doShuffle = 0;  % if du shuffle stat
SVMparams.snrFactor = 1;  % snr factor
ERSPparams.ersplimits = [-1000 1996];
ERSPparams.powerbaseline = [-500 0];
ERSPparams.trialbase = 'full';

conds = {'4' '1'};        % 4 - full recognition, 1 - no recognition
elcs  = [13 27 52 64];    % C3, O1, C4, O2
bins  = genereateBins([-250, 1500], 100, 25);

start_tic = tic;
count_trls = 0;
for s = 1:size(subjects,2)
    %% extract 1 trl ersps:
    for c = 1:size(conds,2)
        filename = [input_name{1}, conds{c} '_', subjects{s}, input_name{2}];
        pathname = [input_path{1}, subjects{s}, input_path{2}];
        EEG = pop_loadset('filename',[filename '.set'] ,'filepath',pathname);
        for t = 1:EEG.trials
            %%
            count_trls = count_trls+1;
            time_vec(count_trls) = toc(start_tic);
            params.numShuffels = EEG.trials;
            reportProgress([subjects{s} '_R' conds{c} ], '1trlERSP extraction for', ...
                count_trls, params, time_vec);
            %%
            for e = 1:size(elcs,2);
                [ersp, timesout, freqsout] = doERSP(EEG, EEG.data(elcs(e),:,t), ERSPparams); % on 1 trial
                results = extractTrialBinsEstimate(ersp, timesout, ...
                    freqsout, bins);
                erspidx(c).alpha(t,:,e) = results.alpha;
                erspidx(c).beta(t,:,e) = results.beta;
            end
            clear results;
        end
        count_trls=0;
    end
    
    %% do svm for 1 subject:
    count_svms = 0;
    for b = 1:size(bins,1)-1
        for e = 1:size(elcs,2);
            %%
            count_svms = count_svms+1; 
            time_vec(count_svms)    = toc(start_tic);
            params.numShuffels = size(elcs,2)*(size(bins,1)-1);
            reportProgress([subjects{s}], 'SVM for', ...
                count_svms, params, time_vec);
            %% 
            realacc(s,b,e).alpha = runSVM ...
                (erspidx(1).alpha(:,b,e), erspidx(2).alpha(:,b,e), SVMparams, []);
            realacc(s,b,e).beta = runSVM ...
                (erspidx(1).beta(:,b,e), erspidx(2).beta(:,b,e), SVMparams, []);
        end
    end
    clear erspidx;
    save('realacc.mat', 'realacc', '-v7.3'); 
end
allsub_realacc(b,e).alpha = mean(realacc(:,b,e).alpha);
allsub_realacc(b,e).beta = mean(realacc(:,b,e).beta);



