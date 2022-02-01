function plot_scatter(x, y, f, ttl, xlbl, ylbl, savename, output_folder)
set(0,'defaultTextInterpreter','latex');

figure('Position', [50 50 700 600]);

plot(f, x, y, 'co', 'filled'); %lsline;

xlabel(xlbl); ylabel(ylbl);
set(gca,'TickDir','out');
set(gca,'FontSize',12)
title(ttl,'FontSize', 15);

saveas(gcf,strcat(output_folder, savename),'png')
% saveas(gcf,strcat(output_folder, savename),'pdf')

close;
end

