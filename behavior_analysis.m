
%% behavior_analysis

subject = 999;
data = importdata([num2str(subject) '.txt']);

actions = data(data(:,1) ~= 4 ,:);
control = data(data(:,1) == 4 ,:);

cnf1_actions = data(data(:,6) == 1 & data(:,1) ~= 4 ,:);
cnf4_actions = data(data(:,6) == 4 & data(:,1) ~= 4 ,:);
cnf1_control = data(data(:,6) == 1 & data(:,1) == 4 ,:);
cnf4_control = data(data(:,6) == 4 & data(:,1) == 4 ,:);

cnf1_actions_present = size(cnf1_actions,1)/size(actions,1)*100;
cnf4_actions_present = size(cnf4_actions,1)/size(actions,1)*100;
cnf1_control_present = size(cnf1_control,1)/size(control,1)*100;
cnf4_control_present = size(cnf4_control,1)/size(control,1)*100;
