% x - concentration; y - response; z - assay; o - odor
function plot_pairwise_assay_paired_comparison(x, y, z, o, ttl, xlbl, ylbl, color, savename, output_folder)

p =signrank(y(:,1), y(:,2));   % p-value 

g=gramm('x', cellstr(z(:)),'y', y(:), 'marker', x(:), 'group', o(:));

%  get horizontal line at mean
bar_width = 0.2;
bar_height = 0.01;
g.geom_polygon('x', {1+[-1 -1 1 1]*bar_width, 2+[-1 -1 1 1]*bar_width}, 'y', ...
    {[(mean(y(:, 1))-bar_height) (mean(y(:, 1))+bar_height) (mean(y(:, 1))+bar_height) (mean(y(:, 1))-bar_height)], ...
    [(mean(y(:, 2))-bar_height) (mean(y(:, 2))+bar_height) (mean(y(:, 2))+bar_height) (mean(y(:, 2))-bar_height)]},...
    'alpha', 0.4);

g.geom_line(); g.geom_point('alpha', 0.5);

% set text parameters
g.set_names('x',xlbl,'y',ylbl, 'size', ['Concentration' newline '(log10)']); 
g.set_title(strcat(ttl, ' [p = ', num2str(p), ', n = ', num2str(size(y,1)), ']'), 'FontSize', 12);

g.axe_property('TickDir', 'out', 'YLim', [-1 1]);
g.set_color_options('map', color);
g.set_order_options('x', 0);

if strcmp(z{1,1}, 'Landing')
    g.set_point_options('base_size', 10,'step_size', 0.5, 'markers', {'s' 'd' '^' 'v' '>' '<' 'p'});
    g.set_line_options('base_size', 0.15, 'step_size', 0.05); 
else
    g.set_point_options('base_size', 10,'step_size', 0.5, 'markers', {'o' 's' 'd' '^' 'v' '>' '<' 'p' 'h' '*'});
    g.set_line_options('base_size', 0.05, 'step_size', 0.05);     
end

figure('Position',[100 100 800 800]);
g.set_text_options('base_size', 12, 'legend_title_scaling', 0.8);
g.geom_hline('yintercept', 0,'style', 'k--');
g.draw();


g.export('file_name', sprintf('%s%s', output_folder, savename), 'file_type', 'jpg');
print(gcf, '-dpdf', sprintf('%s%s.pdf', output_folder, savename));

clear g; close;

end

