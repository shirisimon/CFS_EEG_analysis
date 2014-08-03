
function trialsNum = getTrialsDist()
sub  = {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' ...
    '336' '337' '340' '342' '344' '345' '346' '347' '348' '350'};
trialsNum = zeros(3, 4, size(sub,2));
for s = 1:size(sub,2)
    fileName = [sub{s} '_0.5-40flt_M1M2ref_evtEditedv3_allEpochs'];
    filePath = ['F:\Study 3 - MNS response to invisible actions\EEG\Data\2nd pool data\' sub{s}];
    EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath);
    for t = 1: size(EEG.event,2)
        switch EEG.event(t).type
            case {111, 112, 113, 114}
                trialsNum(1,:,s) = addResponse(trialsNum(1,:,s), EEG.event(t).type, [111 112 113 114]);
            case {121, 122, 123, 124}
                trialsNum(2,:,s) = addResponse(trialsNum(2,:,s), EEG.event(t).type, [121 122 123 124]);
            case {131, 132, 133, 134}
                trialsNum(3,:,s) = addResponse(trialsNum(3,:,s), EEG.event(t).type, [131 132 133 134]);
        end
    end
    for r = 1:4
        trialsNum(:,r,s) = trialsNum(:,r,s)/sum(trialsNum(:,r,s),1)*100;
    end
end
end

function trialNum = addResponse(trialNum, event, triggers)
response = event == triggers;
trialNum = trialNum + response;
end

