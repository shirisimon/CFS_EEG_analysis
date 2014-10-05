
%% compute_allMuSuppInd
clear all
path = 'F:\Study 3 - MNS response to invisible actions\EEG\Analysis\Step 2 - ERSPs\old versions\';
load([path 'allSSERSPv13.mat']);

ind = 0;
for s = 1:size(erspData.subject,2)
    
    for e = [1 3 2 4];  % elc num.
        %% extract bin
        onset  = find(timesout_exp >= 500, 1 );
        offset = find(timesout_exp >= max(timesout_exp), 1 );
        
        %% extract freqs
        alfrq = find(freqsout_exp >= 8, 1);
        ahfrq = find(freqsout_exp <= 13, 1, 'last');
        blfrq = find(freqsout_exp >= 15, 1);
        bhfrq = find(freqsout_exp <= 25, 1,'last');
        
        alowlfrq = find(freqsout_exp >= 8, 1);
        alowhfrq = find(freqsout_exp <= 10, 1, 'last');
        ahighlfrq = find(freqsout_exp >= 10, 1);
        ahighhfrq = find(freqsout_exp <= 13, 1, 'last');
        
        for c = 1:2;      % insert contrast 1,2 (actions) / 3,4 (control-bird) / 4,6 (non-masked action vs. bird)
            ind = ind+1;
            try
                alphaData = erspData.subject{s}.condition{c}.elc{e}.avgERSPData(alfrq:ahfrq,onset:offset);
                betaData  = erspData.subject{s}.condition{c}.elc{e}.avgERSPData(blfrq:bhfrq,onset:offset);
                alphaLowData   = erspData.subject{s}.condition{c}.elc{e}.avgERSPData(alowlfrq:alowhfrq,onset:offset);
                alphaHighData  = erspData.subject{s}.condition{c}.elc{e}.avgERSPData(ahighlfrq:ahighhfrq,onset:offset);
                
            catch err
                alphaData = [];
                betaData  = [];
                alphaLowData   = [];
                alphaHighData  = [];
            end
            allsubErsp_alpah(s,ind) = mean(mean(alphaData));
            allsubErsp_beta(s,ind)  = mean(mean(betaData));
            allsubErsp_low_alpah(s,ind) = mean(mean(alphaLowData));
            allsubErsp_high_alpha(s,ind)  = mean(mean(alphaHighData));
            
            
        end
    end
    
    ind = 0;
end

%% COPY EACH TABLE TO EXCLE SHEET ACCORDING TO FREQUENCY BAND
