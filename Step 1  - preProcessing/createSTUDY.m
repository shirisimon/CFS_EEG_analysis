%% create STUDY
clear all
%% 1. Paramteres:
subjects = {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' ...
            '336' '337' '340' '342' '344' '345' '346' '347' '348' '350'};
fileNameInputExtensions    = ['_0.5-40flt_M1M2ref_evtEditedv3_allEpochs_manRej' ...
                             '_ICA_dipFited_ICrm'];
filePathInputExtentions    = {'F:\study 3\' '\new epochs'};
conditionsInputExtentions  = {'ActRec4' 'ActRec1'};
conditionsOutputExtentions = {'Recognized', 'Not Recognized'};
count                      = 0;
load('minTrlsNum.mat');
minTrlsNum = minTrlsNum(:,[1 2]);

studyName     = 'humanRvsNR_20sub_equalTrlsNum_ICrm';
equalTrls     = 0;
studyNotes    = '';

%% 2. Prepare data sets and std_edit inputs :
% open EEGLAB
% if ~exist('EEG','var')
%     eeglab;
% end

fileNames     = [];
filePaths     = [];
commandsStr   = [];
for s = 1:size(subjects,2);
    for c = 1:size(conditionsInputExtentions,2);
        count             = count+1;
        fileNames{count}  = [conditionsInputExtentions{c} '_' subjects{s} fileNameInputExtensions '.set'];
        filePaths{count}  = [filePathInputExtentions{1} subjects{s} filePathInputExtentions{2} '\equalTrlsNum'];
        if equalTrls
            EEG        = pop_loadset(fileNames{count}, filePaths{count});
            sind       = find(minTrlsNum(:,1) == str2double(subjects{s}));
            if size(EEG.data,3) > minTrlsNum(sind,2);
                EEG = pop_rejepoch( EEG, [minTrlsNum(sind,2):size(EEG.data,3)] ,0);
            end
            filePaths{count} = [filePaths{count} 'equalTrlsNum\'];
            %mkdir([filePaths{count}]);
            pop_saveset(EEG,'filename', fileNames{count}, 'filepath', filePaths{count});
        end
        commands{count*2-1} = {'index', count, 'subject', subjects{s}};
        commands{count*2}   = {'index', count, 'condition', conditionsOutputExtentions{c}};
    end
end
ALLEEG = std_loadalleeg(filePaths,fileNames);

%% 3. create STUDY
STUDY = [];
[STUDY, ALLEEG] = pop_study([], ALLEEG, ...
    'name',      studyName,   ...
    'notes',     studyNotes);

[STUDY, ALLEEG] = std_checkset(STUDY, ALLEEG);
STUDY = pop_savestudy( STUDY, ALLEEG, ...
    'filename', [studyName '.study'], ...
    'filepath', filePathInputExtentions{1}, ...
    'savemode', 'standard');

%% 4. Edit Study
[STUDY, ALLEEG] = std_editset(STUDY, ALLEEG, ...
    'commands',  commands,    ...
    'updatedat', 'on',        ...
    'savedat','on');

[STUDY, ALLEEG] = std_checkset(STUDY, ALLEEG);
STUDY = pop_savestudy( STUDY, ALLEEG, ...
    'filename', [studyName '.study'], ...
    'filepath', filePathInputExtentions{1}, ...
    'savemode', 'standard');



