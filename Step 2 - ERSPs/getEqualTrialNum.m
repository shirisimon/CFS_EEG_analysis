function n = getEqualTrialNum(EEG, conditions)
% return trialNum in the same size of conditions
 n = zeros(1,size(conditions,2));
for t = 1:size(EEG.epoch,2)
    e = str(EEG.epoch(t).eventtype);
    for c = 1:size(conditions,2)
        if sum(ismember(conditions{c}, e))
            n(c) = n(c) + 1;
            break
        end
    end
end
end

function celllist = str(celllist)
    if ~ischar(celllist{1})
        for i = 1:size(celllist,2)
            celllist{i} = num2str(celllist{i});
        end
    end
end
