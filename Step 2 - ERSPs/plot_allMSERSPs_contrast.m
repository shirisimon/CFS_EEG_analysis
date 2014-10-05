
%% plot_contrastERSP

contrast_c3 = STUDY.changrp(1,13).erspdata{1,1} - STUDY.changrp(1,13).erspdata{2,1};
contrast_c4 = STUDY.changrp(1,50).erspdata{1,1} - STUDY.changrp(1,50).erspdata{2,1};

avgContrast_c3 = mean(contrast_c3,3);
avgContrast_c4 = mean(contrast_c4,3);

figure; plotc3 = imagesc(avgContrast_c3);
figure; plotc4 = imagesc(avgContrast_c4);