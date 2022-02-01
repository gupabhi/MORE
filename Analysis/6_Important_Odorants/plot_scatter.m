function plot_scatter(x, y, color, ttl, xlbl, ylbl, savename, output_folder, line_ON, txt)
set(0,'defaultTextInterpreter','latex');
set(gcf, 'Position',  [10, 10, 1000, 800])

[r_value,p_value] = corrcoef(x,y); n = size(x,1);
scatter(x,y,70,color, 'filled'); 

if exist('txt', 'var')
    dx = 0.01; dy = 0.01; % displacement so the text does not overlay the data points
    text(x+dx, y+dy, txt);
end


% lsline;

if line_ON
    hold on;
    plot([-1 1], [-1 1]);
    hleg1  = legend(sprintf('r = %.3f, p = %.3d, n = %d', r_value(1,2), p_value(1,2), n), 'x=y');
else
    hleg1  = legend(sprintf('r = %.3f, p = %.3d, n = %d', r_value(1,2), p_value(1,2), n));
end
xlim([-1, 1]); 
ylim([0, 0.8]);

set(hleg1,'Location','best')
xlabel(xlbl); ylabel(ylbl);
set(gca,'TickDir','out');
set(gca,'FontSize',18);
set(gcf,'PaperSize',[20 15]);
title(ttl,'FontSize', 18);

saveas(gcf,strcat(output_folder, savename),'png')
saveas(gcf,strcat(output_folder, savename),'pdf')

close;
end

