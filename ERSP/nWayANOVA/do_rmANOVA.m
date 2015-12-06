function [ output_args ] = do_rmANOVA( input_args )
%DO_RMANOVA Summary of this function goes here
%   Detailed explanation goes here

load('results_table.mat');
y = t.Result; 
condition = t.Condition; 
hemisphare = t.Hemisphare;
region = t.Region;
band = t.Band;
end

