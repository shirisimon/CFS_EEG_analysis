function reportProgress(fnTosave, jn, i,params, timeVec)

titleStr = sprintf('running %s %s\n start time = %s\n',...
    jn, fnTosave, datestr(clock));
progrSte = sprintf('trial # %d out of %d, %4.2f seconds passed from start\n',...
    i,(params.numShuffels + 1),timeVec(i));
if length(timeVec) >= 2 && i>1
    hrsToFinish = ((timeVec(i) - timeVec(i-1)) * (params.numShuffels+1 - i))/(60*60);
    progReps = ceil(  (i/(params.numShuffels+1)) *30);
    leftReps = 30 - progReps;
    visualPer = sprintf('[%s%s]',repmat('=',1,progReps), repmat(' ',1,leftReps));
    percentCom = sprintf('%2.1f%%', (i/(params.numShuffels+1))*100 );
    projfStr = sprintf('%f hours left\n',hrsToFinish);
else
    projfStr ='';
    percentCom = '';
    visualPer = '';
end

stringToPrint = [titleStr progrSte percentCom visualPer projfStr];

if i ~=1 % delete the previous printed stuff if not the first report
    %     bs1 = sprintf(repmat('\b',1,length(stringToPrint)));
    %     fprintf(bs1);
    clc
end


fprintf('%s',stringToPrint);
if i == params.numShuffels
    f = fopen('last_job.txt', 'a');
    fprintf(f,'%s\n',stringToPrint);
    fclose(f);
end

end