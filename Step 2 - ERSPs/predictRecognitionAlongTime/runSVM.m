function acc = runSVM(dataA, dataB, params, file)
% Exustive permutation is default since we always have <=30 dimentions

if params.doShuffle
    mapsNum = 100; %% shuffle maps num
else
    mapsNum = 1;
end
permNum = size(dataA,1)*size(dataB,1);
allAccs = zeros(permNum,1);
saveReuslts = 0;

%% feature noramlization:
all_data = [dataA; dataB];
all_data_scaled = (all_data-min(all_data(:))) ./ (max(all_data(:)-min(all_data(:))));
idxA = 1:size(all_data_scaled,1)/2;
idxB = idxA(end)+1:size(all_data_scaled,1);
dataA = all_data_scaled(idxA,:); 
dataB = all_data_scaled(idxB,:); 

%% 1. Generate labels
for m = 1:mapsNum; % number of maps (>1 for shuffled labels)
    % SHUFFLE LABELS
    labels = ([ones(size(dataA,1)/params.snrFactor - 1, 1); ...
        ones(size(dataA, 1)/params.snrFactor - 1, 1)*(-1)]); 
    if params.doShuffle
        p = randperm((size(dataA,1)/params.snrFactor)*2-2);
        labels(:,m) = labels(p);
        disp(['Shuffle Progress :' num2str(m) '/' num2str(mapsNum) ]);
    end
    idx = 1:size(dataA);
    p = 0;
    for pa = 1:size(dataA,1);
        for pb = 1:size(dataA,1)
            perm1 = idx([pa, 1:pa-1, pa+1:end]);
            perm2 = idx([pb, 1:pb-1, pb+1:end]);
            dataA_perm = dataA(perm1,:);
            dataB_perm = dataB(perm2,:);
            p = p+1;
            allAccs(p,:) = doSVMfor1Permutation ...
                (dataA_perm, dataB_perm, params.snrFactor, labels(:,m));
        end
    end
    acc1Map = mean(allAccs);
    accForMultiMaps(1,m) = acc1Map;
end

if params.doShuffle
    acc_shuffledLabels = accForMultiMaps(1,:);
    if saveResults; save([file.output_path file.output_name],'acc_shuffledLabels', 'labels','-append'); end
    acc = acc_shuffledLabels;
else
    acc_realLabels = acc1Map;
    allPermutationAcc_realLabels = allAccs;
    if saveReuslts; save([file.output_path file.output_name],'allPermutationAcc_realLabels', 'acc_realLabels', '-append'); end
    acc = acc_realLabels;
end
end


function acc = doSVMfor1Permutation(dataA, dataG, snrfactor, labels)
dataA  = double(dataA);
dataG  = double(dataG);
regionSize = size(dataA,2);

trainA = zeros(size(dataA,1)/snrfactor-1, size(dataA,2));
trainG = zeros(size(dataG,1)/snrfactor-1, size(dataG,2));
testA = zeros(1, regionSize);
testG = zeros(1, regionSize);

perm1 = ceil(1:size(dataA, 1)/snrfactor) ;
perm2 = ceil(1:size(dataA, 1)/snrfactor) ;
if snrfactor > 1
    testA = mean(dataA(find(perm1==1),:));
    testG = mean(dataG(find(perm2==1),:));
else
    testA = dataA(1,:);
    testG = dataG(1,:);
end
for k=1:size(trainA,1)
    if snrfactor > 1
        trainA(k,:) = mean(dataA(find(perm1==k+1),:));
        trainG(k,:) = mean(dataG(find(perm2==k+1),:));
    else
        trainA(k,:) = dataA(find(perm1==k+1),:);
        trainG(k,:) = dataG(find(perm2==k+1),:);
    end
end

trainNoShuffle = [trainA; trainG];
train = trainNoShuffle;%(perm,:);
test = [testA; testG];
predicted = [1;-1];
model = svmtrain(labels, train); % ['-c ', num2str(params.c), ' -g ', num2str(params.g)]);
[~, accuarcy] = svmpredict(predicted, test, model);
acc = accuarcy(1)/100;
end