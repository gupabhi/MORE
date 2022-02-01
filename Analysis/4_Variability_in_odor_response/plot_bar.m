function plot_bar(x, y, color, ttl, xlbl, ylbl, savename, output_folder)
set(0,'defaultTextInterpreter','latex');

g=gramm('x', x,'y', y);
g.geom_bar('dodge',0.9,'width',0.7, 'EdgeColor', 'none');
g.geom_label('color','k','dodge',0.7,'VerticalAlignment','bottom','HorizontalAlignment','center');
g.set_names('x',xlbl,'y',ylbl);
% g.set_order_options('x', 0);
g.geom_hline('yintercept', 0,'style', 'k--');

if strcmp(class(x), 'categorical')
    g.axe_property('XTickLabelRotation', 0, 'TickDir','out', 'YLim', [-1 1]);
%     g.axe_property('TickDir','out','YLim', [-1 1]);
%     g.axe_property('XTickLabelRotation', 45, 'TickDir','out', 'YLim', [-1 1],'XLim', [-10 1]);
else
    g.axe_property('TickDir','out','YLim', [-1 1]);
%     g.axe_property('TickDir','out', 'YLim', [-1 1], 'XLim', [-10 1]);
end

g.set_title(ttl);
g.set_color_options('map', color)
% figure('Position', [0 0 1000 400] + 100)
g.draw();

g.export('file_name', sprintf('%s%s', output_folder, savename), 'file_type', 'jpg');
g.export('file_name', sprintf('%s%s', output_folder, savename), 'file_type', 'svg');
close;

end

