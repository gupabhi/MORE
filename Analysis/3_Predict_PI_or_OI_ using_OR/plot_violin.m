function plot_violin(input, bandwidth, xlbl, ylbl, ttl, savename, output_folder, color)

all_values = input;
m = mean(input); n = size(input,2);

[~, p1] = ttest(all_values, 0);
p2 = signrank(all_values, zeros(size(all_values)), 'Method','exact');

widthViolin = 0.3; bandwidthViolin = bandwidth; widthErrorBar = 0;
sizeLine = 1; sizePoint = 25; sizeText = 11;

idCategory = repelem({sprintf('(p1 = %.2d)(p2 = %.2d)(m = %.2d)(n = %.2d)', p1,p2, m, n)}, 1, length(input(1,:)));

g = gramm('x', idCategory, 'y', all_values);
g.stat_violin('normalization', 'count', 'fill', 'transparent', 'width', widthViolin, 'bandwidth', bandwidthViolin);
g.stat_summary('type', 'sem', 'geom', {'black_errorbar'}, 'width', widthErrorBar);
if max(input) < 0
    ylim = [min(input)*1.2   0];
else
    ylim = [min(input)*1.2   max(input)*1.2];
end
g.axe_property('YLim', ylim,'YGrid', 'on', 'GridLineStyle', '-', 'TickDir', 'out');
g.geom_hline('yintercept', 0,'style', 'k-');

g.set_names('x',xlbl,'y',ylbl); g.set_title(ttl);
g.set_color_options('map', color);

g.set_point_options('base_size', sizePoint);
g.set_text_options('base_size', sizeText);
g.set_line_options('base_size', sizeLine*2);

handleFigure = figure('Position', [100 100 400 300]);
g.draw();

g.export('file_name', sprintf('%s%s', output_folder, savename), 'file_type', 'jpg');
print(gcf, '-dpdf', sprintf('%s%s.pdf', output_folder, savename));

clear g; close;
end

