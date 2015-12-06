function [p,tbl,stats,terms] = do_nWayANOVA()

load('results_table.mat');
y = t.Result; 
condition = t.Condition; 
hemisphare = t.Hemisphare;
region = t.Region;
band = t.Band;
[p,tbl,stats,terms] = anovan(y, {condition, hemisphare, region, band}, ...
    'model','full','varnames', {'condition','hemisphare','region','band'});

% results = multcompare(stats,'Dimension',[1 2])
end

