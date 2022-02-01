function plot_scatter2(x, y, color, ttl, xlbl, ylbl, savename, output_folder)

% set(0,'defaultTextInterpreter','latex');

[r_value,p_value] = corrcoef(x,y); n = size(x,1);

scatter(x,y,50,color, 'filled', 'MarkerFaceAlpha', 0.4); lsline;

ttl = strcat(ttl, ['r = ' num2str(r_value(1,2)),', p = ' num2str(p_value(1,2)),', n = ' num2str(n)]);
title(ttl); xlabel(xlbl); ylabel(ylbl);
% lgd = legend(['r = ' num2str(r_value(1,2)),', p = ' num2str(p_value(1,2)),', n = ' num2str(n)]);
% lgd.Location = 'best';

set(gca,'TickDir','out');
set(findall(gcf,'-property','FontSize'),'FontSize',14)
set(gca,'FontSize',18)
set(gcf,'position',[100,100,550,400])
set(gca, 'TitleFontSizeMultiplier', 0.7);
set(gca, 'FontName', 'Arial')

saveas(gcf,strcat(output_folder, savename),'png')
saveas(gcf,strcat(output_folder, savename),'pdf')

close;
end

