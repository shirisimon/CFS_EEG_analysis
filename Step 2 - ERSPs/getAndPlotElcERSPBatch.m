
%% getAndPlotERSPBatch
clear all
close all

%% 1. Define Parameters:
do_erspboot_subtruction = 0;
trialbase     = 'full';
ersplimits    = [-1000 1996];
powerbaseline = [-600 0];


%% 2. Load primary data if exist:
% file.output_path = ['F:\Study 3 - MNS response to invisible actions\EEG\Results\Step 2 - ERSPs\'...
%     'single subjects ERSPs - clean-COelcs_rmICstrict\with_erspboot\'];
file.output_path = ['C:\s3_2ndpool data backup\results\ctrl\'];
if ~isdir(file.output_path)
    mkdir(file.output_path);
end
subject = {'324' '326' '328' '329' '331' '332' '333' '334' '335' '336' '337' '340'...
    '342' '344' '345' '346' '347' '348' '350'};
condition = {'CtrlRec4', 'CtrlRec1'}; % {'ActRec4' 'ActRec1'};
conditionNum = {{'144'}, {'141'}}; %{{'114', '124', '134'}, {'111' '121' '131'}};
elc = [13 27 50 64];

%% 3. For each subject
for s = 1: size(subject,2)
    file.output_name = [subject{s} '_ERSP'];
    data = struct;
    file.input_name = [subject{s} '_0.5-40flt_M1M2ref_evtEditedv3_allEpochs_manRej'];
    file.input_path = ['C:\\s3_2ndpool data backup\\' subject{s} '\\'];
    %file.input_path = ['F:\\Study 3 - MNS response to invisible actions\\EEG\\Data\\' subject{s} '\\'];
%     switch subject{s}
%         case {'324' '325' '326' '328' }
%             conditionNum = {{'101', '102', '103'}, {'104'}};
%         otherwise
%             conditionNum = {{'105', '106', '107'}, {'108'}};
%     end
    
    %% 4. For each Condition:
    trials =[];
    %ALLEEG = struct; %(1,size(condition,2));
    for c = 1:size(condition,2);
        data(c).condition_name = condition{c};
        file_name = [data(c).condition_name '_' file.input_name];
        file_path = [file.input_path '\\new epochs'];
        EEG = pop_loadset('filename',[file_name '.set'] ,'filepath',file_path);
        ALLEEG(c) = EEG;
        ALLEEG(c) = eeg_checkset(ALLEEG(c));
        trials = [trials, ALLEEG(c).trials];
    end
    trialNum = min(trials);
    
    for c = 1:size(condition,2);
        %% 5. Remove epoched based baseline:
        %EEG = pop_rmbase(EEG, epbaseline);
        
        %% 6. Extract epochs to ERSP limits
        limits = [ceil(1000*ALLEEG(c).xmin) floor(1000*ALLEEG(c).xmax)];
        if ~all(ersplimits == limits)
            limits = ersplimits;
            ALLEEG(c) = pop_epoch(ALLEEG(c), conditionNum{c}, ersplimits/1000, 'epochinfo', 'yes');
        end
        
        %% 7. For each ELectrode - get ERSP:
        for e = 1:size(elc,2)
            data(c).elc{e}.label = ALLEEG(c).chanlocs(elc(e)).labels;
            [ERSP,ITC,~,timesout, freqsout, erspboot] = newtimef( ALLEEG(c).data(elc(e),:,1:trialNum), ...
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