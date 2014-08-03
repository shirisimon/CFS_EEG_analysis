
function extractEpochsBatch()
clear all
subject =  {'351' '352' '353'};
for s = 1:size(subject,2)
    file = struct;
    file.input_path = ['F:\\Study 3 - MNS response to invisible actions\\EEG\\Data\\3rd pool - tests\\' subject{s} '\\'];
    file.input_name = [subject{s} '_0.5-40flt_M1M2ref_evtEdited_manRJ_ICA_dipFited_rmIC_Epochs'];
    EEG = pop_loadset('filename',[file.input_name '.set'] ,'filepath', file.input_path);
    file.output_path = [file.input_path 'Epochs\\'];
    
    %% Control - Actions
    file.output_name = ['controlA_' file.input_name];
    extractEpochs(EEG, {'31' '32' '33'}, [-1.8 2], [], file);
    
    %% Control - Balls
    file.output_name = ['controlB_' file.input_name];
    extractEpochs(EEG, {'34' '35' '36'}, [-1.8 2], [], file);
    
end
end