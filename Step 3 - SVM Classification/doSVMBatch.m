%% doSVM
clear all
type = 'poststimulus';
input_path = ['F:\Study 3 - MNS response to invisible actions\EEG\Results\' ...
    'Step 3 - SVM Classification\' type '_ERSPs\'];
conds = {'ActRec4', 'ActRec1'};
output_path = 'F:\Study 3 - MNS response to invisible actions\EEG\Results\Step 3 - SVM Classification\';
output_name = [output_path conds{1} '-' conds{2} '_SVM_' type '.mat'];
subject = {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' '336' '340'...
                   '342' '344' '345' '346' '347' '348' '350'};
elcs = [13 50 27 64];

%% Params:
% other
allsubjects_accuracy = [];
do_factor = 1;

for s = 1:size(subject,2)
    load([input_path subject{s} '_ERSP.mat']);
    % bins
    onset  = find(timesout >= 500, 1 );
    offset = find(timesout >= max(timesout), 1 );
    % freq bands
    freq(1,:) = [find(freqsout >= 8, 1), find(freqsout <= 13, 1, 'last')];
    freq(2,:) = [find(freqsout >= 15, 1), find(freqsout <= 25, 1, 'last')];
    freq(3,:) = [freq(1,1) freq(2,2)];
    
    eNum = 0;
    for e = elcs;
        eNum = eNum+1;
        eval(['elc_data1 = ' conds{1} '_data.elc' num2str(e) '.allersp;']);
        eval(['elc_data2 = ' conds{2} '_data.elc' num2str(e) '.allersp;']);
        trialNum = min(size(elc_data1,3), size(elc_data2,3));
        elc_data1 = elc_data1(:,:,1:trialNum); % if data1 and data2 dont have the same size
        elc_data2 = elc_data2(:,:,1:trialNum);
        
        disp(['Do SVM for subject: ' num2str(s) ', elc: ' num2str(e)])
        for f = 1:3
            freq_data1 = elc_data1(freq(f,1):freq(f,2),onset:offset,:);
            freq_data2 = elc_data2(freq(f,1):freq(f,2),onset:offset,:);
            freq_data1 = mean(mean(freq_data1));
            freq_data2 = mean(mean(freq_data2));
%             freq_data1 = mean(freq_data1, 2);
%             freq_data2 = mean(freq_data2, 2);
            
            freq_accuracy = 0;
            counter = 0;
            iterations_num = trialNum*4;
            if do_factor
                factor = ceil(trialNum/20);
            else
                factor = 1;
            end
            for ind=1:iterations_num
                perm = floor(rand(1,factor)*(size(freq_data1,3)-1))+1;
                %perm = floor(rand(1,factor)*(size(freq_data2,3)-1))+1;
                % trian set
                mat_train_data1 = freq_data1;
                mat_train_data2 = freq_data2;

                mat_train_data1(:,:,perm) = [];
                mat_train_data2(:,:,perm) = [];
                mat_train_data1 = ReshapeData(mat_train_data1);
                mat_train_data2 = ReshapeData(mat_train_data2);
                for t = 0:size(mat_train_data1,1)/factor-1
                    train_data1(t+1,:) =  mean(mat_train_data1(factor*t+1 : factor*(t+1),:),1);
                    train_data2(t+1,:) =  mean(mat_train_data2(factor*t+1 : factor*(t+1),:),1);
                end
                % test
                test_data1 = freq_data1(:,:,perm);
                test_data2 = freq_data2(:,:,perm,:);
                test_data1 = mean(test_data1,3);
                test_data2 = mean(test_data2,3);
                test_data1 = reshape(test_data1 ,1,size(test_data1 ,2)*size(test_data1 ,1));
                test_data2 = reshape(test_data2 ,1,size(test_data2 ,2)*size(test_data2 ,1));
               
                
                model = svmtrain([repmat(1,size(train_data1,1),1); repmat(2,size(train_data2,1),1)], ...
                    [train_data1; train_data2]);
                [predicted_label, accuracy, prob_estimates] = svmpredict([1;2], [test_data1;test_data2], model);
                freq_accuracy = freq_accuracy + accuracy(1);
                counter=counter+1;
            end
            elc_accuracy(1,f) = freq_accuracy/iterations_num;
            train_data1 = [];
            train_data2 = [];
        end
        allsubjects_accuracy(eNum,:,s)  = [e, elc_accuracy];
    end
    eNum = 0;
end
avg_accuracy = mean(allsubjects_accuracy,3);
med_accuracy = median(allsubjects_accuracy,3);
save(output_name,'allsubjects_accuracy',  'avg_accuracy', 'med_accuracy');