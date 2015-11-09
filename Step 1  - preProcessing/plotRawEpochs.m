function epochs = plotRawEpochs()
%clear all 
close all
subject = {'324'};
s = 1;
condition = 'ActRec4';
events = [114, 124, 134];
elc = 13; % c3
do_condition = 0; %choose if take the condition data set only or all epochs data set

if do_condition
    input_path = ['C:\s3_2ndpool data backup\' subject{s} '\new epochs\'];
    input_name = [condition '_' subject{s} '_0.5-40flt_M1M2ref_evtEditedv3_allEpochs_manRej']; % 
else
    input_path = ['C:\s3_2ndpool data backup\' subject{s}];
    input_name = [subject{s} '_0.5-40flt_M1M2ref_evtEditedv3_allEpochs_manRej']; %  
end
EEG = pop_loadset('filename',[input_name '.set'] ,'filepath', input_path);

epoch_idx = 0;
for ep = 1:size(EEG.data,3)
    relevent =  EEG.epoch(ep).eventtype{2} == events;
    if sum(relevent)
        epoch_idx = epoch_idx+1;
        epochs(epoch_idx,:) = EEG.data(elc,:,ep);
        plot(epochs(1,:), 'color', [rand, rand, rand]);
        hold on
    end
end

end

% sub_allEpochs (maybe without rmbase)
% compare with cond_sub_allEpochs (which I almost sure that are with [-1200
% -1000] rmbase
