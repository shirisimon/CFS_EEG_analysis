
%% RT_behavior_analysis
clear all; close all; clc

subject = {'324' '325' '326' '328' '329' '331' '332' ...
           '333' '334' '335' '336' '340' '342' '344' ...
           '345' '346' '347' '348' '350'};
% conditions names:
conditions = {'ActRec4', 'ActRec1'}; % 'noCFSact', 'noCFSctrl'};
% condition triggers in the data (in the same order of conditions names:
conditionsNum = { {'114', '124', '134'}, ...
                  {'111', '121', '131'}};
              
for s = 1: size(subject,2)
    data = struct;
    file.input_name = [subject{s} '_0.5-40flt_M1M2ref_evtEditedv3'];
    file.input_path = ['C:\study3_MNS and conscious perception\data\' ... 
                       '2nd_pool_data_1stPiplinePreProcessing\' subject{s} '\' ];
    
    %% 4. load subject data set:
    trials =[];
    EEG = pop_loadset('filename',[file.input_name '.set'] ,'filepath',file.input_path);
    
    %% 6. Extract RTs: 
    % trial counters: 
    t1 = 0; % for condition 1
    t2 = 0; % for condition 2
    for e = 1:size(EEG.event,2)
        if ismember(num2str(EEG.event(e).type), conditionsNum{1}) % recognized onset event
            t1 = t1+1; 
            rt1(t1) = EEG.event(e+2).latency - EEG.event(e+1).latency;
        elseif ismember(num2str(EEG.event(e).type), conditionsNum{2}) % not recognized onset event
            t2 = t2+1; 
            rt2(t2) = EEG.event(e+2).latency - EEG.event(e+1).latency;
        end
    end
    trialNum = min(t1,t2);  % make sure we have the same number of trials in the conditions we want to analyze
    allsub_rts{s}(:,1) = rt1(1:trialNum);
    allsub_rts{s}(:,2) = rt2(1:trialNum);
    
    % xls output table: [avgR, avgNR, semR, semNR]
    sem1 = std(rt1(1:trialNum))/sqrt(trialNum);
    sem2 = std(rt2(1:trialNum))/sqrt(trialNum);
    allsub_avg_rt(s,:) = [mean(rt1(1:trialNum)), mean(rt2(1:trialNum)), sem1, sem2];
end


