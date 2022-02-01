function plot_histogram(data, nbins, color, ttl, xlbl, ylbl, savename, output_folder)
set(0,'defaultTextInterpreter','latex');

figure;
histogram(data, nbins, 'FaceColor', color);
title(ttl);
xlabel(xlbl);
ylabel(ylbl);

set(gca,'TickDir','out');
box off;

% save figure
saveas(gcf,strcat(output_folder, savename),'png')
saveas(gcf,strcat(output_folder, savename),'pdf')

close;

end

