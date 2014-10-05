%% plotCohs
clear all
%close all
output_path = 'F:\Study 3 - MNS response to invisible actions\EEG\Results\Step 4 - Coherence\';
output_name = 'coh_poststimulus';
condition = {'ActRec4' 'ActRec1'};

data = matfile([output_path output_name '.mat']);
coh = data.all_cohangles;
elc_pairs = data.elc_pairs;
times = data.times; 
avg_coh = mean(coh,5);

f = 0;
figure;
for p =1:size(elc_pairs,1)
    for c = 1:3
        f = f+1;
        subplot(6,3,f);
        
        if c==3
            contrast = avg_coh(:,:,p,1) -  avg_coh(:,:,p,2);
            h = imagesc(contrast);
            title(['Contrast'] )
        else
            h = imagesc(avg_coh(:,:,p,c));
            title([condition{c} ' - ' elc_pairs{p,1}] );
        end
                   % title
        ylabel('Frequency (Hz)') % label for y axis
        xlabel('Time (ms)')      % label for x axis
        
        %         xlim([times(1), times(end)])            %% from -400 - GENERALIZE
        %         ylim([freqs(1), freqs(end)])            %% [5 30] hz freq range - GENERALIZE
        
        XTicks       = [ 16  48  80  111 143 175 ]; % times indexes  -GENERALIZE
        XTickLabels  = round(times(XTicks)); % real time - GENERLAIZE
        YTicks       = [5 14 24 34 44 54 64]; % GENERLAIZE
        YTicksLabels = [5 10 15 20 25 30 35]; % GENERLAIZE
        
        set(gca, 'XTick', XTicks);
        set(gca, 'YTick', YTicks);
        set(gca, 'XTickLabel', XTickLabels);
        set(gca, 'YTickLabel', YTicksLabels);
        line([48 48],get(gca,'XLim'), 'Color',[0 0 0]);
        set(gca, 'YDir', 'reverse');
        
        %set(axes, 'YAxisLocation', 'Left')
        
        
        
        % add line in onset
        % title, conditions
        % scale bar with units
        % same scale bar between images
        %
        
    end
end

