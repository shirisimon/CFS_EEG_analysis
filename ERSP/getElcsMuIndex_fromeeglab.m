
%% compute_allMuSuppInd
clear; close all; clc;

root = 'G:\study 3_CFS-EEG\data\2nd_pool_data_1stPiplinePreProcessing\';
sub  = {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' '336' ...
    '340' '342' '345' '346' '347' '348'};
idx = 0;
condsNum = 2;
for s = 1:size(sub,2)
    path = [root, sub{s}, '\new epochs\equalTrlsNum\'];
    cidx = 0;
    for c = {'1', '4'};
        cidx = cidx+1;
        if c{1} == '1'; cond = 'Not_Recognized';
        else cond = 'Recognized'; end
        % fname = ['design1_' sub{s} '_' cond '.datersp'];
        fname = ['ActRec' c{1} '_' sub{s} '_0.5-40flt_M1M2ref_evtEditedv3_' ...
            'allEpochs_manRej_ICA_dipFited_ICrm.datersp'];
        dat = importdata([path, fname]);
        display(dat.datatrials)
        eidx = 0;
        for e = {'13' '50' '27' '64'};  % elc num.
            eidx = eidx+1;
            eval(['temp_ersp = dat.chan' e{1} '_ersp;']);
            eval(['temp_erspbase = dat.chan' e{1} '_erspbase;']);
            temp_erspbase = repmat(temp_erspbase',1,200);
            ersp(s,cidx,eidx,:,:) = temp_ersp - temp_erspbase;
            
        end
        eidx = 0;
    end
    cidx = 0;
end

onset  = find(dat.times >= 500, 1 );
offset = find(dat.times >= max(dat.times), 1);
a  = [find(dat.freqs >= 8, 1), find(dat.freqs <= 13, 1, 'last')];
la = [find(dat.freqs >= 8, 1), find(dat.freqs <= 10, 1, 'last')];
ha = [find(dat.freqs >= 11, 1), find(dat.freqs <= 13, 1, 'last')];
b  = [find(dat.freqs >= 15, 1), find(dat.freqs <= 25, 1, 'last')];

c3_la_p  = ersp(:,2,3,la(1):la(2),onset:offset);
c3_la_np = ersp(:,1,3,la(1):la(2),onset:offset);
c4_la_p  = ersp(:,2,4,la(1):la(2),onset:offset);
c4_la_np = ersp(:,1,4,la(1):la(2),onset:offset);

% mean
mc3_la_p  = mean(mean(c3_la_p,4),5);
mc3_la_np = mean(mean(c3_la_np,4),5);
mc4_la_p  = mean(mean(c4_la_p,4),5);
mc4_la_np = mean(mean(c4_la_np,4),5);


