
function EEG = editEvents_v2(EEG)


for evt = 1:size(EEG.event,2);
    if strcmp(EEG.event(1,evt).type,'boundary')
        EEG.event(1,evt).type = 999;
    end
    if ischar(EEG.event(1,evt).type)
        EEG.event(1,evt).type = str2num(EEG.event(1,evt).type);
    end
end


for evt = 1:size(EEG.event,2)-3;
    cfsEvent = EEG.event(1,evt).type == [11 12 13 14];
    if sum(cfsEvent)
        actImage = EEG.event(1,evt+1).type == [21 22 23 24];
        correct_report = responseMap(cfsEvent, actImage);
        if correct_report == EEG.event(1,evt+2).type;
            EEG.event(1,evt).type = EEG.event(1,evt).type*10 + 5;
        else
            EEG.event(1,evt).type = EEG.event(1,evt).type*10 + 6;
        end
        EEG.event(1,evt).type = EEG.event(1,evt).type*10 + ...
            EEG.event(1,evt+3).type;
    end
    
end

% STRING EVENT CASE
% cfsEvent_str = strcmp(EEG.event(1,i).type, {'11' '12' '13' '14'});
% actImage_str = strcmp(EEG.event(1,i).type, {'21' '22' '23' '24'});
% if strcmp(EEG.event(1,i).type, num2str(eval(['10 + ' EEG.event(1,i+2).type]))) || ...
%         strcmp(EEG.event(1,i).type, num2str(eval(['20 + ' EEG.event(1,i+2).type]))) || ...
%         strcmp(EEG.event(1,i).type, num2str(eval(['30 + ' EEG.event(1,i+2).type])));
%     EEG.event(1,i).type = num2str(eval([EEG.event(1,i).type '*10 + 5;']));
% else
%     EEG.event(1,i).type = num2str(eval([EEG.event(1,i).type '*10 + 6;']));
% end
% EEG.event(1,i).type = num2str(eval([EEG.event(1,i).type '*10 + ' ...
%     EEG.event(1,i+3).type]));