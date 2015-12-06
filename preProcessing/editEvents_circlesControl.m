
function EEG = editEvents_circlesControl(EEG)


for evt = 1:size(EEG.event,2);
    if strcmp(EEG.event(1,evt).type,'boundary')
        EEG.event(1,evt).type = 999;
    end
    if ischar(EEG.event(1,evt).type)
        EEG.event(1,evt).type = str2num(EEG.event(1,evt).type);
    end
end


for evt = 1:size(EEG.event,2);
    actionEvent = EEG.event(1,evt).type == [31 32 33];
    ballEvent = EEG.event(1,evt).type == [34 35 36];
    if sum(actionEvent)
        EEG.event(1,evt).type = EEG.event(1,evt).type;
    elseif sum(ballEvent)
        EEG.event(1,evt).type = EEG.event(1,evt).type;
    end
end