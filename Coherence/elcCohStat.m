%% elcCohStat
clear all

%% compute_allMuSuppInd
elc_pair = 'C4-C3';
path = 'C:\Research\Study 3 - MNS response to invisible actions\EEG\Results\Coherence\';
load([path, 'allsub_coh_data_' elc_pair '.mat']);
idx = 0;

do_prestimulus = 1;

do_baseline = 0;
baseline_limits = [-2000 -1000];

for s = 1:size(coh,3)
    %% extract bins
    if do_prestimulus
        onset  = find(times >= -500, 1 );
        offset = find(times >= 0,1); %max(times), 1 );
    else
        onset  = find(times >= 500, 1 );
        offset = find(times >= max(times), 1 );
    end  
    baseline_onset = find(times >= baseline_limits(1), 1 );
    baseline_offset = find(times >= baseline_limits(2), 1 );
    %% extract freqs
    % bands{1} = [find(freqs >= 2, 1), find(freqs <= 3, 1, 'last')]; %high delta
    bands{1} = [find(freqs >= 3, 1), find(freqs <= 4, 1, 'last')]; % delta
    bands{2} = [find(freqs >= 5, 1), find(freqs <= 7, 1, 'last')]; % theta
    bands{3} = [find(freqs >= 8, 1), find(freqs <= 13, 1, 'last')]; % alpha
    bands{4} = [find(freqs >= 15, 1), find(freqs <= 25, 1, 'last')]; % beta
    bands{5} = [find(freqs >= 30, 1), find(freqs <= 40, 1, 'last')]; % gamma
    for b = 1:length(bands);
        for c = 1:2;   % insert contrast 1,2 (actions)
            idx = idx+1;
            try
                data = coh(bands{b}(1):bands{b}(2), onset:offset, s, c);
                baseline_data = coh(bands{b}(1):bands{b}(2), baseline_onset:baseline_offset, s, c);
            catch err
                data = [];
                 baseline_data = [];
            end
            results(s,idx) = mean(mean(data));
            if do_baseline
                baseline_results(s,idx) = mean(mean(baseline_data));
                results(s,idx) = results(s,idx) - baseline_results(s,idx);
            end
        end
    end
    idx = 0;
end

%% COPY EACH TABLE TO EXCLE SHEET ACCORDING TO FREQUENCY BAND
