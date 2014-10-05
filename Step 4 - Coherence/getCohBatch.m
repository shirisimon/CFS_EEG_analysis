%% getAndPlotCohBatch
clear all
close all

%% 1. Define Parameters:
% trialbase     = 'full';
cohlimits    = [-1000 1996];
cohbaseline = [-1000 0];
type = 'poststimulus';

%% 2. Load primary data if exist:
output_path = 'F:\Study 3 - MNS response to invisible actions\EEG\Results\Step 4 - Coherence\';
if ~isdir(output_path)
    mkdir(output_path);
end
subject = {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' '336' '340'...
    '342' '344' '345' '346' '347' '348' '350'};
condition = {'ActRec4' 'ActRec1'};
conditionNum = {{'114', '124', '134'}, {'111' '121' '131'}};
elc = [13 27 50 64];

%% 3. For each subject
elcs_pair = {};
for s = 1: size(subject,2)
    data = struct;
    input_name = [subject{s} '_0.5-40flt_M1M2ref_evtEdited'];
    input_path = ['F:\\Study 3 - MNS response to invisible actions\\EEG\\Data\\' subject{s} '\\'];
    %     EEG = pop_loadset('filename',[file.input_name '.set'] ,'filepath',file.input_path);
    %     trialNum = getEqualTrialNum(EEG, conditionNum); % get trial numbers
    %     trialNum = min(trialNum); % get the minimum trials number to analyze equal trial numbers
    
    %% 4. For each Condition:
    for c = 1:size(condition,2);
        data(c).condition_name = condition{c};
        file_name = [data(c).condition_name '_' input_name];
        file_path = [input_path '\\Epochs'];
        EEG = pop_loadset('filename',[file_name '.set'] ,'filepath',file_path);
        EEG = eeg_checkset(EEG);
        
        %% 5. Remove epoched based baseline:
        %EEG = pop_rmbase(EEG, epbaseline);
        
        %% 6. Extract epochs to Coh limits
        limits = [ceil(1000*EEG.xmin) floor(1000*EEG.xmax)];
        if ~all(cohlimits == limits)
            limits = cohlimits;
            EEG = pop_epoch(EEG, conditionNum{c}, cohlimits/1000, 'epochinfo', 'yes');
        end
        
        %% 7. For each Pair of ELectrodes - get Coherence:
        %         if size(EEG.data,3) < trialNum
        %             trialNum = size(EEG.data,3);
        %         end
        all_pairs = nchoosek(1:size(elc,2),2);
        for p = 1:nchoosek(size(elc,2),2) % all possible pairs
            pair = all_pairs(p,:);
            pair = elc(pair);
            elc_pairs{p,1} = [EEG.chanlocs(pair(1)).labels '-' EEG.chanlocs(pair(2)).labels] ;
             figure;
            [coh,bcoh,times,freqs,cohboot, cohangles] = newcrossf ...
                ( EEG.data(pair(1),:,:), EEG.data(pair(2), :, :), ...
                size(EEG.data,2), ...
                cohlimits, ...
                256, ...
                [3  0.5], ...
                'freqs', [3 40], ...
                'nfreqs', 74, ...
                'padratio', 16, ...
                'baseline', cohbaseline, ...
                'title', ['Subject ' subject{s} ' - Elcs Pair ' elc_pairs{p,1}]);
%             'plotamp', 'off', ...
%                 'plotphase', 'off', ...
               % 'alpha', 0.05);
           
            %close fig 1
            for f = 1:size(freqs,2)
                bc_coh(f,:) = coh(f,:) ./ bcoh(f);
                %sig_coh(f,:) = coh(f,:) - sqrt(cohboot(f));
                %bc_sig_coh(f,:) = bc_coh(f,:) - sqrt(cohboot(f));
            end
            %sig_coh(sig_coh<0) = 0;
            %bc_sig_coh(bc_sig_coh<0) = 0;
            all_scoh(:,:,p,c,s) = coh; % source coh
            all_bc_coh(:,:,p,c,s) = bc_coh; % baseline corrected
            %all_sig_coh(:,:,p,c,s) = sig_coh; % sig. for baseline uncoreected data
            %all_bc_sig_coh(:,:,p,c,s) = bc_sig_coh; % sig. for corrected data
            all_bcoh(:,:,p,c,s) = bcoh; % mean baseline vector
            %all_cohboot(:,:,p,c,s) = cohboot; % sig. upper limit
            all_cohangles(:,:,p,c,s) = cohangles;
            %             data(c).elcs{p}.coh = double(coh);
            %             data(c).elcs{p}.bcoh = double(bcoh);
            %             data(c).elcs{p}.cohangles = double(cohangles);
        end
    end
end
output_name = ['coh_' type];
save([output_path output_name '.mat'], 'all_scoh', 'all_bcoh', 'all_bc_coh', ...
    'all_cohangles', 'times', 'freqs', 'elc_pairs', '-v7.3');


