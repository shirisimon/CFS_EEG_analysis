%% getAndPlot_allSSERSPs_equalTrlsNum
clear all
close all

erspData = struct;
do_ersplimits = 1;
trialbase     = 'full';
ersplimits    = [-1000 1996];
powerbaseline = [-600 0];

save('allSSERSP', 'erspData');
sub  =  {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' ...
         '337' '336' '340' '342' '344' '345' '346' '347' '348' '350' };

condition = {'ActRec4' 'ActRec1'}; %  'CtrlRec4' 'CtrlRec1' 'noCFSact' 'noCFSctrl'};
%condition = {'ActRec34' 'ActRec12' 'CtrlRec34' 'CtrlRec12' 'noCFSact' 'noCFSctrl'};
elc = [13 27 50 64];
trialsNum = [323	23	9	11
    324	87	29	13
    325	77	0	13
    326	34	6	12 % 37
    327	5	1	9
    328	38	19	10
    329	68	72	56
    330	4	1	0
    331	82	6	51
    332	26	73	47
    333	37	4	41
    334	110	45	65
    335	35	12	42
    336	59	21	45
    337	48	12	35
    338	8	6	33
    340	64	38	54
    342	58	18	47
    343	1	17	24
    344	17	8	36
    345	57	43	46
    346	67	13	43
    347	54	53	25
    348	49	26	46
    349	55	13	21
    350	16	34	33
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
                ersplimits    = [-1600 1996];
                powerbaseline = [-1600 -1000];
        end
        fileName  = [condition{c} '_' sub{s} '_0.5-40flt_M1M2ref_evtEditedv3_allEpochs_manRej'];
        filePath  = ['C:\s3_2ndpool data backup\' sub{s} '\new epochs\equalTrlsNum\' ]; %'\new epochs - liberal manRej'];
        EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath);
        EEG = eeg_checkset(EEG);
        
        %% extract epochs to ERSP limits
        limits = [ceil(1000*EEG.xmin) floor(1000*EEG.xmax)];
        if ~all(ersplimits == limits) && do_ersplimits
            switch condition{c}
                case {'ActRec4'}
                    trigger = {'114' '124' '134'};
                case {'ActRec1'}
                    trigger = {'111' '121' '131'};
            end
            limits = ersplimits;
            EEG = pop_epoch(EEG, trigger, ersplimits/1000, 'epochinfo', 'yes');
        end
        
        %% do ERSP
        for e = 1:size(elc,2)
            erspData.subject{s}.condition{c}.elc{e}.label = EEG.chanlocs(elc(e)).labels;
            %figure;
            if trlsNum > size(EEG.data,3)
                trlsNum = size(EEG.data,3);
            end
            [avgERSP,avgITC,~,timesout, freqsout] = newtimef( EEG.data(elc(e),:,:), ... %1:trlsNum), ...
                size(EEG.data,2) , ...
                ersplimits, ...
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
                'baseline', powerbaseline, ...
                'trialbase', trialbase, ...
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
    end
end
freqsout_exp = freqsout;
timesout_exp = timesout;
save('allSSERSP', 'erspData', 'timesout_exp', 'freqsout_exp', ...
    'limits', 'ersplimits', 'powerbaseline', 'trialbase');


