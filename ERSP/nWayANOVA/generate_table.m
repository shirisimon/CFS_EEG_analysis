function generate_table()
% subject, recogntion (1-4)
% hemisphare (left-right), region (central, occipital), frequency (mu, beta), result
% (average ERSP)

% generate_resultstable
clear all; close all; clc;

subjects = {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' '336' ...
    '340' '342' '345' '346' '347' '348'};

curr_dir = pwd;
input_path = {['G:\study 3_CFS-EEG\data\' ...
    '2nd_pool_data_1stPiplinePreProcessing\'],  ...
    '\new epochs\equalTrlsNum\'};
input_files_ext = ['_0.5-40flt_M1M2ref_evtEditedv3_allEpochs_manRej' ...
    '_ICA_dipFited_ICrm'];
output_path = 'G:\study 3_CFS-EEG\Analysis\ERSP\nWayANOVA\';
output_filename = 'table';

bands = {[8 10]; [15 25]};

%% initate tabele:
for s = 1:length(subjects) % itereate over files
    
    for c = {'1', '4'}     % over conditions
        fname = ['ActRec', c{1}, '_', subjects{s}, input_files_ext];
        load('-mat', ...
            [input_path{1}, subjects{s}, input_path{2}, fname '.datersp']);
        freqsout = freqs(1,:);
        timesout = times(1,:);
        onset  = find(timesout >= 500, 1 );
        offset = find(timesout >= max(timesout), 1);
        
        for band = 1:size(bands,1) % over bands
            band_freqs = freqsout>=bands{band}(1)&freqs<=bands{band}(2);
            
            for elc = [13 27 52 64] % over channels
                eval(['ersp = chan' num2str(elc) '_ersp;']);
                switch elc
                    case 13
                        hem = 'left';
                        reg = 'central';
                    case 27
                        hem = 'left';
                        reg = 'occipital';
                    case 52
                        hem = 'right';
                        reg = 'central';
                    case 64
                        hem = 'right';
                        reg = 'occipital';
                end
                result = mean(mean(ersp(band_freqs,onset:offset))); % average power
                % update table:
                new_row = {'Subject', 'Condition', 'Hemisphare',  ...
                    'Band', 'Region', 'Result'; ...
                    {subjects{s}}, ...
                    {c{1}}, ...
                    {hem}, ...
                    {[num2str(bands{band}(1)) '-' num2str(bands{band}(2))]}, ...
                    {reg}, ...
                    result};
                t2app = cell2table(new_row(2:end,:)); % the table 2 append
                t2app.Properties.VariableNames = new_row(1,:);
                try
                    t = [t; t2app];
                catch
                    t = t2app;
                end
            end
        end
    end
    
end

save([output_path, output_filename '.mat'], 't');



