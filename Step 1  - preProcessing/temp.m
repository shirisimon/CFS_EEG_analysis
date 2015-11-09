
%% extract the epochs idx from old data sets
clear all
subject = {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' '336' '340'...
    '342' '344' '345' '346' '347' '348' '350'};
condition = {'ActRec4' 'ActRec1'};
conditionNum = {{'114', '124', '134'}, {'111' '121' '131'}};
epochRang = [-2 2];

for s = 1: size(subject,2)
    %     newfile.input_name = [subject{s} '_0.5-40flt_AVGref_evtEdited'];
    %     newfile.input_path = ['F:\\Study 3 - MNS response to invisible actions\\EEG\\Data\\' subject{s} '\\'];
    %     EEG = pop_loadset('filename',[newfile.input_name '.set'] ,'filepath',newfile.input_path);
    %
    %     %% Extract to allEpochs Set:
    %     EEG = extractEpochs(EEG, [conditionNum{1}(1,:) conditionNum{2}(1,:)], epochRang);
    %     newfile.output_name = [newfile.input_name '_allEpochs'];
    %     pop_saveset( EEG, 'filename',[ newfile.output_name '.set'],'filepath', newfile.input_path);
    %
    for c = 1:2
        newlist = 0;
        oldlist = 0;
        
        %         allEpochsEEG = pop_loadset('filename',[newfile.output_name '.set'] ,'filepath',newfile.input_path);
        %         newEEG = extractEpochs(allEpochsEEG, conditionNum{c}, epochRang);
        newfile.input_name = [condition{c} '_' subject{s} '_0.5-40flt_M1M2ref_evtEdited'];
        newfile.input_path = ['F:\\Study 3 - MNS response to invisible actions\\EEG\\Data\\' subject{s} '\\Epochs\\'];
        newEEG = pop_loadset('filename',[newfile.input_name '.set'] ,'filepath',newfile.input_path);
        
        oldfile.input_name  = [condition{c} '_' subject{s} '_0.5-40flt_M1M2ref_evtEditedv3_allEpochs_manRej'];
        oldfile.input_path  = ['C:\s3_2ndpool data backup\' subject{s} '\new epochs\equalTrlsNum\' ];
        oldEEG = pop_loadset('filename',[oldfile.input_name '.set'] ,'filepath',oldfile.input_path);
        
        for t = 1:newEEG.trials
            newlist(t) = newEEG.epoch(t).eventurevent{2};
        end
        for t = 1:oldEEG.trials
            oldlist(t) = oldEEG.epoch(t).eventurevent{2};
        end
        
%         removed_trials{c} = find(~ismember(newlist,oldlist));
        % validation
        
%         try
%             all(oldlist == newlist(ismember(newlist,oldlist)))
%         catch err
            size(oldlist,2)
            size(newlist,2)
            sum(~ismember(newlist,oldlist))
%         end
%         
%         newEEG = pop_rejepoch(newEEG, removed_trials{c}, 1);
%         EEG = newEEG;
%         EEG = pop_reref(EEG, [69 70]);
%         file.output_name = [condition{c} '_' subject{s} '_0.5-40flt_M1M2ref_evtEdited'];
%         file.output_path = [newfile.input_path 'Epochs\\'];
%         if ~isdir(file.output_path)
%             mkdir(file.output_path);
%         end
%         pop_saveset( EEG, 'filename',[ file.output_name '.set'],'filepath', file.output_path);
    end
%    save([file.output_path 'removed_trials'], 'removed_trials');
end
%%

% for s = 1:4
%     for t = 1:ALLEEG(s).trials
%         elist{s,1}(t,1) = ALLEEG(s).epoch(t).eventurevent{2};
%     end
% end
