
function trialNum = getTrialsNum()
sub  = {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' ...
        '336' '337' '340' '342' '344' '345' '346' '347' '348' '350'};
condition = {'ActRec4' 'ActRec3' 'ActRec2' 'ActRec1' ...
             'CtrlRec4' 'CtrlRec3' 'CtrlRec2' 'CtrlRec1'...
             'noCFSact' 'noCFSctrl'};

for s = 1:size(sub,2)
    for c = 1:size(condition,2)
        fileName = [condition{c} '_' sub{s} ...
            '_0.5-40flt_M1M2ref_evtEditedv3_allEpochs_manRej']; %_manRej'];

        filePath = ['F:\study 3\' sub{s} '\new epochs']; %- liberal manRej'];                        
        
        try 
        EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath);
        trialNum(s,c) = size(EEG.data,3);
        catch err
             continue
        end
        
    end
end
