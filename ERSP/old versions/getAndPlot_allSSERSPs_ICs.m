
% if ~exist('allSub_ERSPs', 'file');
    erspData = struct;
    save('allSSERSPs', 'erspData');
% else
    % load('allSub_ERSPs');
% end
sub  = {'329' '331' '332' '333' '334' '335' '336' '337'};
condition = {'ActRec4' 'ActRec1' 'CtrlRec4' 'CtrlRec1' 'noCFSact' 'noCFSctrl'};
comp = [329 26 18; ...
         331 17 6 ; ...
         332 0  19; ...
         333 10 4 ; ...
         334 28 20; ...
         335 20 15; ...
         336 11 7 ; ...
         337 16 3]; 
         
startInd = size(erspData,2);
for s = startInd: size(sub,2)
    erspData.subject{s}.name = sub{s};
    for c = 1:size(condition,2);
        erspData.subject{s}.condition{c}.name = condition{c};
        switch condition{c}
            case {'noCFSact' 'noCFSctrl'}
                eepoch    = [-1600 1996];
                bbaseline = [-1600 -1000];
            otherwise
                eepoch    = [-1000 1996];
                bbaseline = [-1000 0];
        end
        fileName  = [condition{c} '_' sub{s} '_0.5-40flt_M1M2ref_' ...
            'evtEditedv3_allEpochs_ICA_dipFited_ICrm_autoRej'];
        filePath  = ['F:\study 3\' sub{s} '\new epochs'];                       
        
        try 
        EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath);
        EEG = eeg_checkset(EEG);
        for e = 2:3
            figure;
            [avgERSP,avgITC,~,timesout, freqsout] = pop_newtimef( EEG, 0, ...
                comp(s,e), ...
                eepoch, ...
                [3         0.5] , ...
                'alpha',0.05,...
                'freqs', [3 35], ...
                'nfreqs', 32, ...
                'plotphase', 'off', ...
                'padratio', 2, ...
                'baseline', bbaseline, ...
                'trialbase', 'off', ...
                'erspmax', 2.5, ...
                'verbose', 'off');
              %saveas(gcf, [sub{s} '_' condition{c} '_'  EEG.chanlocs(elc(e)).labels], 'jpg');
              close fig 1
            
        erspData.subject{s}.condition{c}.elc{e-1}.avgERSPData = double(avgERSP);
        end
        
        if s == size(sub,2) && c == 6
            freqsout_control = freqsout;
            timesout_control = timesout;
            save('allSSERSPs', 'freqsout_control', 'timesout_control', '-append');
        end
        
        catch err
            continue
        end
    end
end
freqsout_exp = freqsout;
timesout_exp = timesout;
save('allSSERSPs', 'erspData', 'timesout_exp', 'freqsout_exp', '-append');


