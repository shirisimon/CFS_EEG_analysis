%% getAndPlot_allSSERSPs_equalTrlsNum

% if ~exist('allSub_ERSPs', 'file');
    erspData = struct;
    save('allSSERSPs', 'erspData');
% else
    % load('allSub_ERSPs');
% end

sub  =  {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' ...
         '336' '337' '340' '342' '343' '344' '345' '346' '347' '348' '350' }; 
condition = {'ActRec4' 'ActRec1'}; %  'CtrlRec4' 'CtrlRec1' 'noCFSact' 'noCFSctrl'};
%condition = {'ActRec34' 'ActRec12' 'CtrlRec34' 'CtrlRec12' 'noCFSact' 'noCFSctrl'};
elc = [13 27 50 64];

trialsNum = [323	23	9	11
             324	88	29	13
             325	78	0	13
             326	35	6	12
             327	6	1	9
             328	39	19	10
             329	69	72	56
             330	5	1	0
             331	83	6	51
             332	27	73	47
             333	38	4	41
             334	111	45	65
             335	36	12	42
             336	60	21	45
             337	49	12	35
             338	9	6	33
             340	65	38	54
             342	59	18	47
             343	1	17	24
             344	18	8	36
             345	58	43	46
             346	68	13	43
             347	55	53	25
             348	50	26	46
             349	56	13	21
             350	17	34	33
];


startInd = size(erspData,2);
for s = startInd: size(sub,2)
    erspData.subject{s}.name = sub{s};
    for c = 1:size(condition,2);
        sind = find(trialsNum(:,1) == str2double(sub{s}));
        switch c
            case {1,2}
                cind = 2;
            case {3,4}
                cind = 3;
            case {5,6}
                cind = 4;
        end
        trlsNum = trialsNum(sind,cind);
        erspData.subject{s}.condition{c}.name = condition{c};
        switch condition{c}
            case {'noCFSact' 'noCFSctrl'}
                eepoch    = [-1600 1996];
                bbaseline = [-1600 -1000];
            otherwise
                eepoch    = [-600 1996];
                bbaseline = [-1000 0];
        end
        % fileName = [condition{c} '_' sub{s} '_0.5-40flt_M1M2ref_MANrej_ICA_ICrm_evtEditedv3'];
        fileName  = [condition{c} '_' sub{s} '_0.5-40flt_M1M2ref_' ...
            'evtEditedv3_allEpochs_manRej'];
        filePath  = ['F:\study 3\' sub{s} '\new epochs\equalTrlsNum' ]; %'\new epochs - liberal manRej'];   %                     
        try 
        EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath);
        EEG = eeg_checkset(EEG);
        for e = 1:size(elc,2)
            erspData.subject{s}.condition{c}.elc{e}.label = EEG.chanlocs(elc(e)).labels;
            %figure;
            [avgERSP,avgITC,~,timesout, freqsout] = newtimef( EEG.data(elc(e),:,1:trlsNum), ...
                size(EEG.data,2) , ...
                eepoch, ...
                256, ...
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
                'verbose', 'off');
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


