clear all
close all
% if ~exist('allSub_ERSPs', 'file');
    erspData = struct;
    save('allSSERSPs', 'erspData');
% else
    % load('allSub_ERSPs');
% end

sub  =  {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' ...
         '336' '337' '340' '342' '344' '345' '346' '347' '348' '350'}; 
condition = {'ActRec4' 'ActRec1'}; % 'CtrlRec4' 'CtrlRec1' 'noCFSact' 'noCFSctrl'};
%condition = {'ActRec34' 'ActRec12' 'CtrlRec34' 'CtrlRec12' 'noCFSact' 'noCFSctrl'};
elc = [13 27 50 64];

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
                eepoch    = [-1600 1996];
                bbaseline = [-1000 0];
        end
        % fileName = [condition{c} '_' sub{s} '_0.5-40flt_M1M2ref_MANrej_ICA_ICrm_evtEditedv3'];
        fileName  = [condition{c} '_' sub{s} '_0.5-40flt_M1M2ref_' ...
            'evtEditedv3_allEpochs_manRej_ICA_dipFited_ICrm'];
        filePath  = ['C:\s3_2ndpool data backup\' sub{s} '\new epochs\equalTrlsNum\' ]; %'\new epochs - liberal manRej'];   %                     
        try 
        EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath);
        EEG = eeg_checkset(EEG);
        for e = 1:size(elc,2)
            erspData.subject{s}.condition{c}.elc{e}.label = EEG.chanlocs(elc(e)).labels;
            %figure;
            [avgERSP,avgITC,~,timesout, freqsout] = pop_newtimef( EEG, ...
                1,elc(e) , ...
                eepoch, ...
                [3         0.5] , ...
                'topovec', elc(e), ...
                'elocs', EEG.chanlocs, ...
                'chaninfo', EEG.chaninfo, ...
                'alpha',0.05,...
                'freqs', [3 35], ...
                'nfreqs', 64, ...
                'plotphase', 'off', ...
                'padratio', 2, ...
                'baseline', bbaseline, ...
                'trialbase', 'full', ... 
                'erspmax', 2.5, ...
                'verbose', 'off',...
                'title', [sub{s} '-' condition{c} '-' EEG.chanlocs(elc(e)).labels]);
              %saveas(gcf, [sub{s} '_' condition{c} '_'  EEG.chanlocs(elc(e)).labels], 'jpg');
               close fig 1
            erspData.subject{s}.condition{c}.elc{e}.avgERSPData = double(avgERSP);
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


