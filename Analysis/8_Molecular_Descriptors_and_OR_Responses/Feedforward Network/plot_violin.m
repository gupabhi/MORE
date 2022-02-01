function plot_violin(x, label, bandwidth, color, savename, output_folder)
% Note: x -> col vector

% calculate mean, n, p_ttest, p_signrank
m = mean(x);
n = size(x,1);
[~, p_ttest] = ttest(x, 0);
p_signrank = signrank(x, zeros(size(x)), 'Method','exact');
% p_signrank = signrank(x, y, 'Method','exact');

% plot parameters
widthViolin = 0.3; 
bandwidthViolin = bandwidth; 
widthErrorBar = 0;
sizeLine = 2; 
sizePoint = 15; 
sizeText = 21;

% get y values and title
y = repelem({''}, length(x), 1);
ttl = sprintf('(p_ttest = %.2d)(p_signrank = %.2d)(m = %.2d)(n = %.2d)', ...
    p_ttest, p_signrank, m, n);

% set plot design
g = gramm('x', y, 'y', x);
g.stat_violin('normalization', 'count', 'fill', 'transparent', 'width', widthViolin, 'bandwidth', bandwidthViolin);
g.stat_summary('type', 'sem', 'geom', {'black_errorbar'}, 'width', widthErrorBar);
g.axe_property('YGrid', 'on', 'GridLineStyle', '-', 'TickDir', 'out');
g.set_color_options('map', color);
g.set_names('x', '', 'y', label);
g.set_title(ttl, 'FontSize', 12);
g.set_point_options('base_size', sizePoint);
g.set_text_options('base_size', sizeText);
% objPlot.axe_property('YLim', [5  -30],'YGrid', 'on', 'GridLineStyle', '-', 'TickDir', 'out');

% draw the figure
handleFigure = figure('Position', [100 100 600 500]);
g.set_line_options('base_size', sizeLine*2);
g.draw();

% save the figure
saveas(gcf, sprintf('%s%s%s', output_folder, savename, '.png'));
saveas(gcf, sprintf('%s%s%s', output_folder, savename, '.pdf'));

% close everything
close(handleFigure);
clear objPlot

end

