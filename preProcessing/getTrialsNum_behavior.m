
function [ansMat_corrects, ansMat_acts] = getTrialsNum_behavior()
% for all types of actions 
% ansMat_corrects - for each cnf levels how many trials were correctly vs
% incorrectly recognized
% ansMat_acts - for each cnf level hoe many trials were of each action type
sub  = {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' ...
    '336' '340' '342' '344' '345' '346' '347' '348' '350'};  
ansMat_corrects = zeros(length(sub),8); % 4 cnf levels * 2 corrects (true or false)
ansMat_acts = zeros(length(sub),12); % 4 cnf levels * 3 actions
for s = 1:size(sub,2)
    fileName = [sub{s}  '_0.5-40flt_AVGref']; 
    filePath = ['C:\Research\Study 3 - MNS response to invisible actions\EEG\Data\2nd_pool_data_2ndPiplinePreProcessing\' sub{s} ]; %- liberal manRej'];
    EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath);
    EEG = editEvents_v2(EEG,1);
    EEG = eeg_checkset(EEG);
    
    for e = 1:size(EEG.event,2);
         % disp(EEG.event(e).type);
        if EEG.event(e).type > 1000; % CFS stimulus onset
            try
            response = num2str(EEG.event(e).type); 
            cnf = response(4); 
            rec = response(3);
            act = response(2);
            if str2double(cnf)*3 - str2double(act)+1 == 12
                disp('stop here')
            end
            ansMat_corrects(s, str2double(cnf)*2 - str2double(rec)) = ...
                ansMat_corrects(s, str2double(cnf)*2- str2double(rec)) +1;
            ansMat_acts(s,  str2double(cnf)*3 - str2double(act)+1) = ...
                ansMat_acts(s, str2double(cnf)*3 - str2double(act)+1) +1;
            catch err
                continue
            end
        end
    end
end
