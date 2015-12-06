
%% getAndPlotERSPBatch
clear all
close all
% eeglab

%% 1. Define Parameters:
extract_epochs = 0;
do_erspboot_subtruction = 0;
trialbase     = 'full';
ersplimits    = [-1000 1996];
powerbaseline = [-500 0];


%% 2. Load primary data if exist:
% file.output_path = ['F:\Study 3 - MNS response to invisible actions\EEG\Results\Step 2 - ERSPs\'...
%     'single subjects ERSPs - clean-COelcs_rmICstrict\with_erspboot\'];
file.output_path = ['C:\study3_MNS and conscious perception\Results\ERSPs\allcond_new\'];
if ~isdir(file.output_path)
    mkdir(file.output_path);
end
subject = {'324' '325' '326' '328' '329' '331' '332' ...
    '333' '334' '335' '336' '340' '342' '344' ...
    '345' '346' '347' '348' '350'};
conditions = {'ActRec4', 'ActRec1', 'CtrlRec4', ...
    'CtrlRec1', 'noCFSact', 'noCFSctrl'};
conditionsNum = { {'114', '124', '134'}, ...
    {'111', '121', '131'}, ...
    {'144'}, {'141'}};
% conditions = {'fullRec', 'partRec', 'noRec'}; % {'ActRec4' 'ActRec1'};
% conditionsNum = {{'114', '124', '134'}, {'112' '122' '132' '113' '123' '133'}, {'111' '121' '131'}};
% conditions = {'fullRec', 'noRec'}; % {'ActRec4' 'ActRec1'};
% conditionsNum = {{'114', '124', '134'}, {'111' '121' '131'}};
% conditions = {'bright', 'dark'}; % {'ActRec4' 'ActRec1'};
% conditionsNum = {{'31' '32' '33'}, {'34' '35' '36'}};
elc = [13 27 50 64];

%% 3. For each subject
for s = 1: size(subject,2)
    file.output_name = [subject{s} '_ERSP_elcs'];
    data = struct;
    file.input_name = [subject{s} '_0.5-40flt_M1M2ref_evtEditedv3_allEpochs_manRej_ICA_dipFited_ICrm'];
    file.input_path = ['F:\WD SmartWare.swstor\203-MUKAMEL-1\onlyBackup_0115\'...
        'projects_olderVersions\s3_CFS-EEG\EEG_data\' ...
        '2nd_pool_data_1stPiplinePreProcessing\' subject{s} '\new epochs\' ];
    
    switch subject{s}
        case {'324' '325' '326' '328' }
            conditionsNum{5} = {'101', '102', '103'};
            conditionsNum{6} = {'104'};
        otherwise
            conditionsNum{5} = {'105', '106', '107'};
            conditionsNum{6} = {'108'};
    end
    
    %% 4. For each Condition:
    trials =[];
    for c = 1:size(conditions,2);
    file.input_name = [conditions{c} '_' file.input_name];
    EEG = pop_loadset('filename',[file.input_name '.set'] ,'filepath',file.input_path);
        data(c).condition_name = conditions{c};
        trials = [trials, EEG.trials];
    end
    trialNum = min(trials);
    
    for c = 1:size(conditions,2);
        %% 5. Remove epoched based baseline:
        %EEG = pop_rmbase(EEG, epbaseline);
        %% 6. Extract epochs to ERSP limits
        limits = [ceil(1000*ALLEEG(c).xmin) floor(1000*ALLEEG(c).xmax)];
        if ~all(ersplimits == limits)
            limits = ersplimits;
            try ALLEEG(c) = pop_epoch(ALLEEG(c), conditionsNum{c}, ersplimits/1000, 'epochinfo', 'yes');
            catch err
            end
        end
        
        %% 7. For each ELectrode - get ERSP:
        for e = 1:size(elc,2)
            data(c).elc{e}.label = ALLEEG(c).chanlocs(elc(e)).labels;
            try [ERSP,ITC,~,timesout, freqsout, erspboot] = newtimef( ALLEEG(c).data(elc(e),:,1:trialNum), ...
                    size(ALLEEG(c).data,2) , ...
                    ersplimits, ...
                    256, ...
                    [3         0.5] , ...
                    'topovec', elc(e), ...
                    'elocs', ALLEEG(c).chanlocs, ...
                    'chaninfo', ALLEEG(c).chaninfo, ...
                    'alpha',0.01,...
                    'freqs', [3 35], ...
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