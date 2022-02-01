function plot_scatter(x, y, color, ttl, xlbl, ylbl, savename, output_folder, line_ON, txt)

set(0,'defaultTextInterpreter','latex');
% set(0,'defaultAxesFontSize',40)
set(gcf, 'Position',  [50, 50, 1050, 900])

[r_value,p_value] = corrcoef(x,y); n = size(x,1);
scatter(x,y,70,color, 'filled'); %lsline;

if exist('txt', 'var')
    dx = 5; dy = 10; % displacement so the text does not overlay the data points
    text(x+dx, y+dy, txt);
end

if line_ON
    hold on;
    plot([-1 1], [-1 1]);
    legend(sprintf('r = %.3f, p = %.3d, n = %d', r_value(1,2), p_value(1,2), n), 'x=y')
else
    legend(sprintf('r = %.2f, p = %.2d, n = %d', r_value(1,2), p_value(1,2), n))
end

xlim([-1 1]);
ylim([-1 1]);
set(gca,'TickDir','out');
set(gca,'FontSize',18)
set(gcf,'PaperSize',[20 15]);

xlabel(xlbl); ylabel(ylbl);
title(ttl,'FontSize', 18);

saveas(gcf,strcat(output_folder, savename),'png')
saveas(gcf,strcat(output_folder, savename),'pdf')

close;
end

