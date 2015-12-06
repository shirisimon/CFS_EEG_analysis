
function trialNum = getCondsTrialsNum()
sub  = {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' ...
    '336' '340' '342' '344' '345' '346' '347' '348' '350'};  
rec_conds = {'ActRec4' 'ActRec3' 'ActRec2' 'ActRec1'};
act_conds = {1, 2, 3};


for s = 1:size(sub,2)
    fileName = [sub{s} '_0.5-40flt_M1M2ref_allEpochs_clean'];
    filePath = ['C:\Research\Study 3 - MNS response to invisible actions\EEG\Data\' sub{s}]; %- liberal manRej'];
    EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath);
    idx = 0;
    for rc = 1:size(rec_conds,2)
        for ac = 1:size(act_conds,2)
            idx = idx+1;
%             try
                % trialNum(s,c) =size(EEG.data,3);
                trialNum(s,idx) = getTrialNum(EEG,rec_conds{rc}, act_conds{ac});
%             catch err
%                 continue
%             end
            
        end
    end
end
end

    function trialNum = getTrialNum(EEG, rec_cond, act_cond)
        switch rec_cond
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
            rec = EEG.epoch(t).eventtype{2} == evt;
            act = find(rec);
            if sum(rec);
                if act == act_cond
                    trialNum = trialNum+1;
                end
            end
        end
    end


