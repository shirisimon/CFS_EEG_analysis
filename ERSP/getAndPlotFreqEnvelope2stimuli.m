%% plotFreqEnvelop
clear all
close all

% params:
plot = 0;
freq = [15 25];
path = ['C:\study3_MNS and conscious perception\Results\ERSPs\' ...
    'current\hum_3levels\'];
% all subjects: 
% subject = {'324' '325' '326' '328' '329' '331' ...
%            '332' '333' '334' '335' '336' '340' ...
%            '342' '344' '345' '346' '347' '348' '350'};
% NH subjects: 
% subject = {'324' '329' '332' '334' '336' '340' ...
%            '345' '347' '348' '350'};
% 3 levels subjects: 
subject = {'326' '331' '333' '334' '335' '340' ...
           '342' '345' '346' '348' '350'};

colors = ['b', 'r', 'r', 'r', 'b', 'r'];
envelop_db = zeros(length(subject), 12);
cidx = 0;
for c = 1:3; % insert contrast 1,2 (actions) / 3,4 (control-bird) / 5,6 (non-masked action vs. bird)
    cidx = cidx+1;
    for s = 1:size(subject,2) 
        load([path, subject{s} '_ERSP_elcs.mat']);
        idx=0;
        for e = [1 3 2 4];  % elc num.
            idx = idx+1;
            onset  = find(timesout >= 0, 1 );
            offset = find(timesout >= max(timesout), 1 );
            band = [find(freqsout >= freq(1), 1), find(freqsout <= freq(2), 1, 'last')];
            try 
               mat = data(c).elc{e}.ERSP(band(1):band(2),onset:offset);
                envelop(s,:) = mean(mat);
                if cidx==1
                    envelop_db(s,3*idx-2) = getFreqEnvelope2stimuliIndex(envelop(s,:), ...
                        timesout, onset, offset);
                elseif cidx==2
                    envelop_db(s,3*idx-1) = getFreqEnvelope2stimuliIndex(envelop(s,:), ...
                        timesout, onset, offset);
                elseif cidx==3
                    envelop_db(s,3*idx) = getFreqEnvelope2stimuliIndex(envelop(s,:), ...
                        timesout, onset, offset);
                end
                %plot(envelop(s,:), 'color', colors(c)); % [rand, rand, rand]);
                %hold on;
            catch err; envelop_db(s,c) = NaN;
            end
        end
    end
    if plot
        avg_envelop = mean(envelop);
        sem = std(envelop)/sqrt(length(subject));
%         d = designfilt('lowpassiir','FilterOrder',12, 'HalfPowerFrequency',1.5,'DesignMethod','butter');
%         filt_avg_envelop = filtfilt(d,avg_envelop);
%         filt_sem = filtfilt(d,sem);
        lines = {'color', colors(c), 'LineWidth', 2};
        elc = data(c).elc{e}.label;
        shadedErrorBar(timesout(onset:offset), avg_envelop, sem, lines, 1);
        title([elc ' envelop to signal @ band ' num2str(freq(1)) '-' num2str(freq(2)) 'Hz'] , ...
            'FontSize', 14);
        hold on;
    end
end

%% COPY EACH TABLE TO EXCLE SHEET ACCORDING TO FREQUENCY BAND
