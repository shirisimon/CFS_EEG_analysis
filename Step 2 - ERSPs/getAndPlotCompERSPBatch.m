
%% getAndPlotERSPBatch
clear all
close all

%% 1. Define Parameters:
ics_field = 'all';
do_erspboot_subtruction = 1;
trialbase     = 'full';
ersplimits    = [-2000 1996];
powerbaseline = [-1600 -1000];


%% 2. Define files patterns:
file.output_path = ['F:\Study 3 - MNS response to invisible actions\EEG\Results\Step 2 - ERSPs\'...
    'single_subjects_cmps_ERSPs\'];
if ~isdir(file.output_path)
    mkdir(file.output_path);
end
subject = {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' '336' '340'...
    '342' '344' '345' '346' '347' '348' '350'};
condition = {'ActRec4', 'ActRec1'};
conditionNum = {{'114', '124', '134'}, {'111' '121' '131'}};
comps = {'left_central_mu', 'right_central_mu', 'central_occipital_alpha'};
load(['F:\\Study 3 - MNS response to invisible actions\\EEG\\Data\\functional_components.mat']);

% subject = {'324' '328' '329' '332' '334' '336' '340'...
%     '342' '345' '347' '348' '350'};
% condition = {'ActRec4', 'ActRec1', 'CtrlRec4', 'CtrlRec1', 'noCFSact', 'noCFSctrl'};
% conditionNum = {{'114', '124', '134'}, {'111' '121' '131'}, {'144'}, {'141'}};
% comps = {'left_central_mu', 'right_central_mu', ...
%     'left_occipital_alpha', 'right_occipital_alpha', 'central_occipital_alpha'};
% load(['F:\\Study 3 - MNS response to invisible actions\\EEG\\Data\\' ...
%     '2nd_pool_data_oldPiplinePreProcessing\\functional_components.mat']);

%% For each subject
for s = 1: size(subject,2)
    %% 3. Define more file patterns:
    data = struct;
    file.input_name = [subject{s} '_0.5-40flt_M1M2ref_evtEdited_clean-COelcs_rmICstrict_dipFitted'];
    file.input_path = ['F:\\Study 3 - MNS response to invisible actions\\EEG\\Data\\' subject{s} '\\'];
    %file.input_name = [subject{s} '_0.5-40flt_M1M2ref_evtEditedv3_allEpochs_manRej_ICA_dipFited_ICrm'];
    %file.input_path = ['F:\\Study 3 - MNS response to invisible actions\\EEG\\Data\\'...
    %'2nd_pool_data_oldPiplinePreProcessing\\' subject{s} '\\'];
    %     switch subject{s}
    %         case {'324' '325' '326' '328' }
    %             conditionNum{5} = {'101', '102', '103'};
    %             conditionNum{6} = {'104'};
    %         otherwise
    %             conditionNum{5} = {'105', '106', '107'};
    %             conditionNum{6} = {'108'};
    %     end
    
    %% 4. For each Condition pair, extract the min trial Nuber:
    trials =[];
    %ALLEEG = struct; %(1,size(condition,2));
    for c = 1:size(condition,2);
        file.output_name = [subject{s} 'prestimulus_ersp'];
        data(c).condition_name = condition{c};
        file_name = [data(c).condition_name '_' file.input_name];
        %         file_path = [file.input_path '\\new epochs'];
        file_path = [file.input_path '\\Epochs'];
        EEG = pop_loadset('filename',[file_name '.set'] ,'filepath',file_path);
        ALLEEG(c) = EEG;
        ALLEEG(c) = eeg_checkset(ALLEEG(c));
        trials = [trials, ALLEEG(c).trials];
    end
    trialNum = min(trials);
    %trialNum = [min(trials(1:2)), min(trials(3:4)), min(trials(5:6))];
    
    for c = 1:size(condition,2);
        %% 5. Remove epoched based baseline:
        %EEG = pop_rmbase(EEG, epbaseline);
        
        %% 6. Extract epochs to ERSP limits
        limits = [ceil(1000*ALLEEG(c).xmin) floor(1000*ALLEEG(c).xmax)];
        if ~all(ersplimits == limits)
            limits = ersplimits;
            ALLEEG(c) = pop_epoch(ALLEEG(c), conditionNum{c}, ersplimits/1000, 'epochinfo', 'yes');
            if ALLEEG(c).trials > trialNum(ceil(c/2))
                epochs2reject = [trialNum(ceil(c/2))+1:ALLEEG(c).trials];
                log2rejepoch = [zeros(1,trialNum(ceil(c/2))), ones(1, ALLEEG(c).trials - trialNum(ceil(c/2)))];
                ALLEEG(c) = pop_rejepoch(ALLEEG(c), log2rejepoch, 0);
            end
        end
        
        %% Get IC indecies for each functional component:
        eval(['allics = comps_' subject{s} '.' ics_field '.all;']);
        for fc = 1:size(comps,2) % itereate over the functional components
            eval([comps{fc} ' = comps_' subject{s} '.' ics_field '.' comps{fc} ';']);
            for ic = 1:size(allics,2) % itereate over all the independent components
                eval(['exp = ismember(allics(ic), ' comps{fc} ');']);
                if exp % if the IC belongs to the functional component
                    data(c).comp{ic}.label = comps{fc}; % assign to IC its FC label
                    %% 7.  get ERSP for each independent component:
                    [ERSP,ITC,~,timesout, freqsout, erspboot] = pop_newtimef( ALLEEG(c), 0, allics(ic), ...
                        limits, ...
                        [3         0.5] , ...
                        'alpha',0.01,...
                        'freqs', [3 35], ...
                        'nfreqs', 64, ...
                        'plotphase', 'off', ...
                        'plotersp', 'on', ...
                        'plotitc', 'off', ...
                        'padratio', 2, ...
                        'baseline', powerbaseline, ...
                        'trialbase', trialbase, ...
                        'title', [subject{s} ' - ' condition{c} ' - IC ' num2str(allics(ic)) ' - ' data(c).comp{ic}.label], ...
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
        
    end
    
    %% 7. Save results:
    save([file.output_path file.output_name '.mat'], 'data', 'timesout', 'freqsout', 'trialNum', ...
        'trialbase', 'ersplimits', 'powerbaseline');
end
