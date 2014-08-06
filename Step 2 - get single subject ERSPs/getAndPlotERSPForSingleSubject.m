
%% getAndPlotERSPsingleSubjectERSP
clear all

%% 1. Load primary data if exist:
file.output_path = 'F:\\Study 3 - MNS response to invisible actions\\EEG\\Results\\Step 2 - single subject ERSPs\\';
if ~isdir(file.output_path)
    mkdir(file.output_path);
end

%% 2. Define parameters:
subject = {'351' '352' '353'};
condition = {'controlA' 'controlB'};
conditionNum = {{'31' '32' '33'}, {'34' '35' '36'}};
elc = [13 27 50 64];

%% 3. For each subject
for s = 1: size(subject,2)
    file.output_name = 'ERSP';
    data = struct;
    file.input_name = [subject{s} '_0.5-40flt_M1M2ref_evtEdited_manRJ_ICA_dipFited_rmIC_Epochs'];
    file.input_path = ['F:\\Study 3 - MNS response to invisible actions\\EEG\\Data\\3rd pool - tests\\' subject{s} '\\'];
    EEG = pop_loadset('filename',[file.input_name '.set'] ,'filepath',file.input_path);
    trialNum = getEqualTrialNum(EEG, conditionNum); %get trial numbers
    trialNum = min(trialNum); %get the minimum to analyze equal trial numbers
    %% 4. For each Condition:
    for c = 1:size(condition,2);
        data(c).condition_name = condition{c};
        epoch    = [-1600 1996];
        baseline = [-1600 0];
        file_name = [data(c).condition_name '_' file.input_name];
        file_path = [file.input_path 'Epochs\\'];
        
        EEG = pop_loadset('filename',[file_name '.set'] ,'filepath',file_path);
        EEG = eeg_checkset(EEG);
        %% 5. For each ELectrode - get ERSP:
        for e = 1:size(elc,2)
            data(c).elc{e}.label = EEG.chanlocs(elc(e)).labels;
            [ERSP,ITC,~,timesout, freqsout] = newtimef( EEG.data(elc(e),:,1:trialNum), ...
                size(EEG.data,2) , ...
                epoch, ...
                256, ...
                [3         0.5] , ...
                'topovec', elc(e), ...
                'elocs', EEG.chanlocs, ...
                'chaninfo', EEG.chaninfo, ...
                'alpha',0.05,...
                'freqs', [3 35], ...
                'nfreqs', 64, ...
                'plotphase', 'off', ...
                'padratio', 2, ...
                'baseline', baseline, ...
                'trialbase', 'full', ...
                'verbose', 'off');
            % saveas(gcf, [sub{s} '_' condition{c} '_'  EEG.chanlocs(elc(e)).labels], 'jpg');
            close fig 1
            data(c).elc{e}.ERSP = double(ERSP);
        end
        
    end
    file.output_name = [subject{s} '_' file.output_name];
    save([file.output_path file.output_name '.mat'], 'data', 'timesout', 'freqsout');
end
%% 6. Save results:



