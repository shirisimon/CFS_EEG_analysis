
%% get_resultsMat
clear all
%close all
%% parameters
SSERSPsfileName = 'allSSERSPs_20subHumRvsNR_equalTrlsNum.mat';
load(SSERSPsfileName);
conditionInd = 2; 
elcIndex     = 1;

%% crate 3D arrays and mean of multi-subjects ERSPs
for c = 1:size(erspData.subject{1}.condition,2)
    for e = 1:size(erspData.subject{1}.condition{1}.elc,2)
        for s = 1:size(erspData.subject,2)
            msERSP.condition{c}.elc{e}(:,:,s) = erspData.subject{s}.condition{c}.elc{e}.avgERSPData;
        end
        meanMsERSP.condition{c}.elc{e} = mean(msERSP.condition{c}.elc{e},3);
    end
end

%% plot spectograms
figure;
h = imagesc(meanMsERSP.condition{conditionInd}.elc{elcIndex});

title('ERSP')            % title
ylabel('Frequency (Hz)') % label for y axis
xlabel('Time (ms)')      % label for x axis

xlim([5 200])            %% from -400 - GENERALIZE
ylim([6  54])            %% [5 30] hz freq range - GENERALIZE
    
XTicks       = [ 16  48  80  111 143 175 ]; % times indexes  -GENERALIZE
XTickLabels  = [-300 0   300 600 900 1200]; % real time - GENERLAIZE
YTicks       = [5 14 24 34 44]; % GENERLAIZE
YTicksLabels = [5 10 15 20 25]; % GENERLAIZE

set(gca, 'XTick', XTicks);
set(gca, 'YTick', YTicks);
set(gca, 'XTickLabel', XTickLabels);
set(gca, 'YTickLabel', YTicksLabels);
line([48 48],get(gca,'XLim'), 'Color',[0 0 0]);
%set(gca, 'YDir', 'reverse');

%set(axes, 'YAxisLocation', 'Left')



% add line in onset
% title, conditions
% scale bar with units
% same scale bar between images
% 
