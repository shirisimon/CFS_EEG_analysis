
%% getAndPlotERSPBatch
clear all; close all; clc

%% 1. Define Parameters:
extract_epochs          = 0;
do_erspboot_subtruction = 0;
trialbase               = 'full';
ersplimits              = [-1000 1996];
powerbaseline           = [-1000 0];
epbaseline              = [-1200 -1000];

file.output_path = ['C:\study3_MNS and conscious perception\Results\ERSPs\' ...
                    'current\cfs_baseline_ERD\'];
if ~isdir(file.output_path); mkdir(file.output_path); end

% subjects' name list
subject = {'324' '325' '326' '328' '329' '331' '332' ...
           '333' '334' '335' '336' '340' '342' '344' ...
           '345' '346' '347' '348' '350'};

% conditions names:
conditions = {'ActRec4', 'ActRec1',  'CtrlRec4', 'CtrlRec1'}; % 'noCFSact', 'noCFSctrl'};

% condition triggers in the data (in the same order of conditions names:
conditionsNum = { {'114', '124', '134'}, ...
                  {'111', '121', '131'}, ...
                  {'144'}, ...
                  {'141'} };

              % save electrodes from :
elc = [13 27 50 64]; % C3, O1, C4, O2

%% 3. For each subject
for s = 1: size(subject,2)
    file.output_name = [subject{s} 'cfsConds_ERSP-elcs'];
    data = struct;
    file.input_name = [subject{s} '_0.5-40flt_M1M2ref_evtEditedv3_allEpochs_manRej_ICA_dipFited_ICrm'];
    file.input_path = ['C:\study3_MNS and conscious perception\data\' ... 
                       '2nd_pool_data_1stPiplinePreProcessing\' subject{s} '\' ];
    
    %% 4. load subject data set:
    trials =[];
    EEG = pop_loadset('filename',[file.input_name '.set'] ,'filepath',file.input_path);
    for c = 1:size(conditions,2);
        data(c).condition_name = conditions{c};
        %%  extract epochs of condition 'c':
        try % if no epochs in this condiiton
            new_EEG = pop_epoch( EEG, conditionsNum{c}, [-1.6 2], 'epochinfo', 'yes');
            ALLEEG(c) = new_EEG;
            ALLEEG(c) = eeg_checkset(ALLEEG(c));
        catch err
            ALLEEG(c) = EEG;
            ALLEEG(c).trials = 0;
            ALLEEG(c).data = [];
        end
        trials = [trials, ALLEEG(c).trials]; % concatinate trials number
    end
    trialNum(1:2) = min(trials(1:2));  % make sure we have the same number of trials in the conditions we want to analyze
    trialNum(3:4) = min(trials(3:4));
    
    %% prepre data of each condition to newtimef:
    for c = 1:size(conditions,2);
        % Remove epoched based baseline: (if not removed already)
        % EEG = pop_rmbase(EEG, epbaseline);
        % Extract epochs to ERSP limits
        limits = [ceil(1000*ALLEEG(c).xmin) floor(1000*ALLEEG(c).xmax)];
        if ~all(ersplimits == limits)
            limits = ersplimits;
            try ALLEEG(c) = pop_epoch(ALLEEG(c), conditionsNum{c}, ersplimits/1000, 'epochinfo', 'yes');
            catch err
            end
        end
        
        %% 7. get ERSP For each Electrode :
        for e = 1:size(elc,2)
            data(c).elc{e}.label = ALLEEG(c).chanlocs(elc(e)).labels;
            try [ERSP,ITC,~,timesout, freqsout, erspboot] = newtimef( ALLEEG(c).data(elc(e),:,1:trialNum(c)), ...
                    size(ALLEEG(c).data,2) , ...
                    ersplimits, ...
                    256, ... % sampling rate
                    [3         0.5] , ... % cycles (starting from 3 minimum)
                    'topovec', elc(e), ...
                    'elocs', ALLEEG(c).chanlocs, ...
                    'chaninfo', ALLEEG(c).chaninfo, ...
                    'alpha',0.01,...
                    'freqs', [7 40], ... % frequency range 
                    'nfreqs', 64, ...
                    'plotphase', 'off', ...
                    'plotersp', 'off', ...
                    'plotitc', 'off', ...
                    'padratio', 2, ...
                    'baseline', powerbaseline, ...
                    'trialbase', trialbase, ...
                    'verbose', 'off');
            catch err; ERSP = []; 
            end
            % 'cycles', [3 0.5], 'alpha',0.05, 'freqs', [3 35], 'nfreqs', 64, 'padratio', 2, 'baseline', [-600 0 ], 'trialbase', 'full'
            % saveas(gcf, [sub{s} '_' condition{c} '_'  ALLEEG(c).chanlocs(elc(e)).labels], 'jpg');
            % close fig 1
            if do_erspboot_subtruction
                for f =1:freqsout;
                    ERSP(f,ERSP(f,:)>erspboot(f,1) & ERSP(f,:)<erspboot(f,2)) = 0;
                end
            end
            data(c).elc{e}.ERSP = double(ERSP);
        end
        
    end
    %% 7. Save results:
    save([file.output_path file.output_name '.mat'], 'data', 'timesout', 'freqsout', 'trialNum', ...
        'trialbase', 'ersplimits', 'powerbaseline');
end