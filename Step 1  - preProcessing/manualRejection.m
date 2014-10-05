%% temp2
clear all
% eeglab
subject = {'350'};
% condition = {'ActRec1'}; 
input_name = [subject{1} '_0.5-40flt_AVGref_evtEdited_allEpochs_ICA'];
input_path = ['F:\\Study 3 - MNS response to invisible actions\\EEG\\Data\\' subject{1} '\\']; %Epochs\\'];
EEG = pop_loadset('filename', [input_name '.set'], 'filepath', input_path);
pop_eegplot(EEG,0,1,1);
% eegplot(EEG.data([13 50 27 64],:,:), 'spacing', 40, 'command', 0);
%%
rejepochs = floor(TMPREJ(:,1)./1024)+1;
EEG = pop_rejepoch(EEG, rejepochs, 0);
output_name = [input_name '_clean-ICA'];
pop_saveset(EEG, 'filename', [output_name '.set'], 'filepath', input_path);
