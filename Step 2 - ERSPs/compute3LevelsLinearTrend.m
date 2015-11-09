%% computeLinearTrend
% code inspired by here: http://davidmlane.com/hyperstat/B114903.html
% warning: this code is not equvalent with linear trend analysis in
% statistica

%% load data for each channel as 'mat'

%% compute SSE
remove_avg = mat - repmat(mean(mat,1),11,1);
power2 = remove_avg .^ 2;
for j = 1:size(mat,2)
    sse(j) = sum(power2(:,j));
end
SSE = sum(sse);

%% more definitions
df = size(mat,1) - size(mat,2);
a = [-1, 0, 1];
n = size(mat,1);

%% Compute L, SL:
L = sum(mean(mat) .* a);
MSE = SSE/df;
for j = 1:size(mat,2)
    sl(j) = a(j)^2 / n;
end
SL = sqrt(sum(sl)*MSE);

%% stats
tscore = L / SL;
pval = 1-tcdf(tscore,df); 
disp(pval)


