
function trialNum = getTrialsNum()
sub  = {'324' '325' '326' '328' '329' '331' '332' '333' '335' ...
    '336' '340' '342' '344' '345' '346' '347' '348' '350'};  %'334'
condition = {'ActRec4' 'ActRec3' 'ActRec2' 'ActRec1'};
% condition = {'ActRec4' 'ActRec3' 'ActRec2' 'ActRec1' ...
%              'CtrlRec4' 'CtrlRec3' 'CtrlRec2' 'CtrlRec1'...
%              'noCFSact' 'noCFSctrl'};

for s = 1:size(sub,2)
    fileName = [sub{s} ...
        '_0.5-40flt_M1M2ref_evtEditedv3_allEpochs_manRej_ICA_dipFited_ICrm']; %_ICA_clean-ICA_2ndICA_dipFited']; %_manRej'];
    filePath = ['C:\Research\Study 3 - MNS response to invisible actions\EEG\Data\\2nd_pool_data_oldPiplinePreProcessing\' sub{s} ]; %- liberal manRej'];
    EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath);
    for c = 1:size(condition,2)
        try
            % trialNum(s,c) =size(EEG.data,3);
            trialNum(s,c) = getTrialNum(EEG,condition{c});
        catch err
            continue
        end
        
    end
end
end

function trialNum = getTrialNum(EEG, cond)
switch cond
    case 'ActRec4'
        evt = [114, 124, 134];
    case 'ActRec3'
        evt = [113, 123, 133];
    case 'ActRec2'
        evt = [112, 122, 132];
    otherwise
        evt = [111, 121, 131];
end

trialNum = 0;
for t = 1:EEG.trials
    if sum(EEG.epoch(t).eventtype{2} == evt); trialNum = trialNum+1; end
end
end
