function results = extractTrialBinsEstimate(ersp,timesout, ...
    freqsout, bins)
% predict recognition accuracy from baseline until estimated recognition

for b = 1:size(bins,1) % time bins
    %% extract bin
    onset  = find(timesout >= bins(b,1), 1);
    offset = find(timesout >= bins(b,2), 1);
    %% extract freqs
    alpha  = [find(freqsout >= 8, 1), find(freqsout <= 13, 1, 'last')];
    lalpha = [find(freqsout >= 8, 1), find(freqsout <= 10, 1, 'last')];
    halpha = [find(freqsout >= 11, 1), find(freqsout <= 13, 1, 'last')];
    beta   = [find(freqsout >= 15, 1), find(freqsout <= 25, 1, 'last')];
    gamma  = [find(freqsout >= 30, 1), find(freqsout <= 40, 1, 'last')];
    %% extract sub-spectogram
    alpah_data  = ersp(alpha(1):alpha(2),onset:offset);
    beta_data   = ersp(beta(1):beta(2),onset:offset);
    lalpha_data = ersp(lalpha(1):lalpha(2),onset:offset);
    halpha_data = ersp(halpha(1):halpha(2),onset:offset);
    gamma_data  = ersp(gamma(1):gamma(2),onset:offset);
    %% extract power estimate
    results.alpha(b)  = mean(mean(alpah_data));
    results.beta(b)   = mean(mean(beta_data));
    results.lalpha(b) = mean(mean(lalpha_data));
    results.halpha(b) = mean(mean(halpha_data));
    results.gamma(b)  = mean(mean(gamma_data));
end
end








