function plot_violin(x, y, ttl, xlbl, ylbl, color, bandwidth, output_folder)
bandwidth = 0.001;
sizeLine = 1; sizePoint = 80; sizeText = 20; widthViolin = 2; widthErrorBar = 0;
% sizeLine = 1; sizePoint = 80; sizeText = 10; widthViolin = 0.2; widthErrorBar = 0;  % for deltaPI plot

g=gramm('x',x,'y',y,'color',x);

g.stat_violin('normalization', 'width', 'fill', 'transparent', 'width', widthViolin, 'bandwidth', bandwidth);
% g.stat_violin('normalization', 'count', 'fill', 'transparent', 'width', widthViolin, 'bandwidth', bandwidth);
g.stat_summary('type', 'sem', 'geom', {'black_errorbar'}, 'width', widthErrorBar);

g.set_names('x',xlbl,'y',ylbl); g.set_title(ttl, 'FontSize', 15);
% g.axe_property('YGrid', 'on', 'GridLineStyle', '-', 'TickDir', 'out', 'YLim', [-1 1], 'XTick', unique(x), 'XLim', [(min(x)-0.4) (max(x)+0.4)]);
% g.axe_property('YGrid', 'on', 'GridLineStyle', '-', 'TickDir', 'out');
g.axe_property('YGrid', 'on', 'GridLineStyle', '-', 'TickDir', 'out', 'YLim', [-1.5 0.5]); % for deltaPI plot

g.set_point_options('base_size', sizePoint);
g.set_text_options('base_size', sizeText);
g.set_line_options('base_size', sizeLine*2);
g.set_layout_options('legend', false);
g.geom_hline('yintercept', 0,'style', 'k--');

figure('Position',[100 100 (size(unique(x),1)*100 + 250) 700]);

g.draw();

g.export('file_name', sprintf('%s%s', output_folder, ttl{1}), 'file_type', 'jpg');
print(gcf, '-dpdf', sprintf('%s%s.pdf', output_folder, ttl{1}));

clear g; close;
end

