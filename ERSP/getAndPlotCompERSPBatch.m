
%% getAndPlotERSPBatch
clear all
close all

%% 1. Define Parameters:
ics_field = 'all';
do_erspboot_subtruction = 0;
trialbase = 'full';
ersplimits = [-1000 1996];
powerbaseline = [-500 1996];


%% 2. Define files patterns:
file.output_path = ['C:\Research\Study 3 - MNS response to invisible actions\EEG\Results\' ...
    'ERSPs\3levels_exp\'];
if ~isdir(file.output_path)
    mkdir(file.output_path);
end
subject = {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' '336' '340'...
    '342' '344' '345' '346' '347' '348' '350'};
condition = {'full_rec', 'part_rec', 'no_rec'};
conditionsNum ={{'114', '124', '134'}, {'112' '122' '132' '113' '123' '133'}, {'111' '121' '131'}};
% condition = {'full_rec', 'no_rec'};
% conditionsNum ={{'114', '124', '134'} {'111' '121' '131'}};
comps = {'left_mu', 'right_mu', 'left_alpha', 'right_alpha'};
load(['C:\Research\Study 3 - MNS response to invisible actions\' ...
    'EEG\Data\functional_comps_loc.mat']);

%% For each subject
for s = 1: size(subject,2)
    %% 3. files patterns:
    data = struct;
    % source of IC exp file
    tfile.input_name = [subject{s} '_0.5-40flt_M1M2ref_allEpochs_clean2_ICA_dipFited_ICrm'];
    tfile.input_path = ['C:\\Research\\Study 3 - MNS response to invisible actions\\' ...
        'EEG\\Data\\' subject{s} '\\'];
    % source of IC loc file
    sfile.input_name = [subject{s} '_0.5-40flt_M1M2ref_locEpochs_clean_ICA_clean_ICA2nd_dipFited'];
    sfile.input_path = tfile.input_path;
    
    trials =[];
    tIC_EEG = pop_loadset('filename',[tfile.input_name '.set'] ,'filepath',tfile.input_path);
    sIC_EEG = pop_loadset('filename',[sfile.input_name '.set'] ,'filepath',sfile.input_path);
    tIC_EEG.icawinv = sIC_EEG.icawinv;
    tIC_EEG.icasphare = sIC_EEG.icasphere;
    tIC_EEG.icachansind = sIC_EEG.icachansind;
    tIC_EEG.icaweights = sIC_EEG.icaweights;
    
    %% 4. For each Condition pair, extract the min trial Nuber:
    for c = 1:size(condition,2);
        file.output_name = [subject{s} '_ERSP_cmps'];
        data(c).condition_name = condition{c};
        % file_name = [data(c).condition_name '_' file.input_name];
        % file_path = [file.input_path '\\new epochs'];
        new_EEG = pop_epoch( tIC_EEG, conditionsNum{c}, [-2.5 2], 'epochinfo', 'yes');
        ALLEEG(c) = new_EEG;
        ALLEEG(c) = eeg_checkset(ALLEEG(c));
        trials = [trials, ALLEEG(c).trials];
    end
    trialNum = min(trials);
    % trialNum = [min(trials(1:2)), min(trials(3:4)), min(trials(5:6))];
    
    for c = 1:size(condition,2);
        %% 5. Remove epoched based baseline:
        % EEG = pop_rmbase(EEG, epbaseline);
        
        %% 6. Extract epochs to ERSP limits
        limits = [ceil(1000*ALLEEG(c).xmin) floor(1000*ALLEEG(c).xmax)];
        if ~all(ersplimits == limits)
            limits = ersplimits;
            ALLEEG(c) = pop_epoch(ALLEEG(c), conditionsNum{c}, ersplimits/1000, 'epochinfo', 'yes');
            if ALLEEG(c).trials > trialNum
                epochs2reject = [trialNum+1:ALLEEG(c).trials];
                log2rejepoch = [zeros(1,trialNum), ones(1, ALLEEG(c).trials - trialNum)];
                ALLEEG(c) = pop_rejepoch(ALLEEG(c), log2rejepoch, 0);
            end
        end
        
        %% Get IC indecies for each functional component:
        for ic = 1:size(comps,2) % itereate over the functional components
            data(c).comp{ic}.label = comps{ic}; % assign to IC its functional label
            %% 7.  get ERSP for each independent component:
            comp = functional_comps_loc(s,ic);
            if comp ~= 0;
                [ERSP,ITC,~,timesout, freqsout, erspboot] = pop_newtimef( ALLEEG(c), 0, comp, ...
                    limits, ...
                    [3         0.5] , ...
                    'alpha',0.01,...
                    'freqs', [3 35], ...
                    'nfreqs', 64, ...
                    'plotphase', 'off', ...
                    'plotersp', 'off', ...
                    'plotitc', 'off', ...
                    'padratio', 2, ...
                    'baseline', powerbaseline, ...
                    'trialbase', trialbase, ...
                    'title', [subject{s} ' - ' condition{c} ' - IC ' num2str(comp) ' - ' data(c).comp{ic}.label], ...
                    'verbose', 'off');
                % 'cycles', [3 0.5], 'alpha',0.05, 'freqs', [3 35], 'nfreqs', 64, 'padratio', 2, 'baseline', [-600 0 ], 'trialbase', 'full'
                % saveas(gcf, [sub{s} '_' condition{c} '_'  ALLEEG(c).chanlocs(elc(e)).labels], 'jpg');
                close fig 1
                if do_erspboot_subtruction
                    for f =1:freqsout;
                        ERSP(f,ERSP(f,:)>erspboot(f,1) & ERSP(f,:)<erspboot(f,2)) = 0;
                    end
                end
                data(c).comp{ic}.ERSP = double(ERSP);
            end
        end
    end
    
    %% 7. Save results:
    save([file.output_path file.output_name '.mat'], 'data', 'timesout', 'freqsout', 'trialNum', ...
        'trialbase', 'ersplimits', 'powerbaseline');
end
