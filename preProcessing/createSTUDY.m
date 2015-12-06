%% create STUDY
clear; close all; clc;

%% 1. Paramteres:
do_dipfit = 0;
subjects = {'324' '325' '326' '328' '329' '331' '333' '332' '334' '335' ...
                    '336' '340' '342' '345' '346' '347' '348'};
fileNameInputPattern = '_0.5-40flt_M1M2ref_evtEditedv3_allEpochs_manRej_ICA_dipFited_ICrm';
filePathInputPattern = {'G:\study 3_CFS-EEG\data\2nd_pool_data_1stPiplinePreProcessing'};
conds  = {'ActRec4' 'ActRec1'}; % 'CtrlRec4', 'CtrlRec1', 'noCFSact', 'noCFSctrl'};
% conds  = {'noMask_act'};
count   = 0;
% load('minTrlsNum.mat');
% minTrlsNum = minTrlsNum(:,[1 2]);

studyName  = '19subjects_withICA';
studyNotes = '';

%% 2. Prepare std_edit inputs :
fileNames = [];
filePaths  = [];
commandsStr   = [];
for s = 1:size(subjects,2);
    for c = 1:size(conds,2);
        count = count+1;
        fileNames{count}  = [conds{c} '_' subjects{s} fileNameInputPattern '.set'];
        % fileNames{count}  = [subjects{s} fileNameInputPattern '.set'];
        filePaths{count}  = [filePathInputPattern{1} '\' subjects{s} '\new epochs\equalTrlsNum\'];
        %% do dipole fitting
        if do_dipfit
            EEG = pop_loadset('filename', [fileNames{count}], 'filepath', filePaths{count});
            EEG = pop_dipfit_settings( EEG, 'hdmfile','C:\\toolbox\\eeglab12_0_1_0b\\plugins\\dipfit2.2\\standard_BESA\\standard_BESA.mat',...
                'coordformat','Spherical', ...
                'mrifile','C:\\toolbox\\eeglab12_0_1_0b\\plugins\\dipfit2.2\\standard_BESA\\avg152t1.mat', ...
                'chanfile','C:\\toolbox\\eeglab12_0_1_0b\\plugins\\dipfit2.2\\standard_BESA\\standard-10-5-cap385.elp', ...
                'chansel', 1:64);
            EEG = pop_multifit(EEG, [1:70] ,'threshold',100,'dipplot','off');
            fileNames{count} = [fileNames{count} '_dipFitted.set'];
            EEG = pop_saveset(EEG, 'filename', [fileNames{count}], 'filepath', filePaths{count});
        end
        commands{count*3-2} = {'index', count, 'subject', subjects{s}};
        commands{count*3-1} = {'index', count, 'condition', conds{c}};
        commands{count*3} = {'inbrain', 'on', 'dipselect', 0.3};
    end
end
ALLEEG = std_loadalleeg(filePaths,fileNames);

%% 3. create STUDY
[STUDY, ALLEEG] = pop_study([], ALLEEG,  'name', studyName, 'notes', studyNotes);

[STUDY, ALLEEG] = std_checkset(STUDY, ALLEEG);
STUDY = pop_savestudy( STUDY, ALLEEG, ...
    'filename', [studyName '.study'], ...
    'filepath', filePathInputPattern{1}, ...
    'savemode', 'standard');

%% 4. Edit Study
[STUDY, ALLEEG] = std_editset(STUDY, ALLEEG, ...
    'commands',  commands,    ...
    'updatedat', 'on',        ...
    'savedat','on');

[STUDY, ALLEEG] = std_checkset(STUDY, ALLEEG);
STUDY = pop_savestudy( STUDY, ALLEEG, ...
    'filename', [studyName '.study'], ...
    'filepath', filePathInputPattern{1}, ...
    'savemode', 'standard');



