% x - assay; y - response;
function plot_pairwise_comparison(x, y, z, ttl, xlbl, ylbl, color, savename, output_folder)

p = signrank(y(:,1), y(:,2));
n = size(y,1);

g=gramm('x', cellstr(x(:)),'y', y(:), 'group', z(:));

%  get horizontal line at mean
bar_width = 0.2;
bar_height = 0.005;
g.geom_polygon('x', {1+[-1 -1 1 1]*bar_width, 2+[-1 -1 1 1]*bar_width}, 'y', ...
    {[(mean(y(:, 1))-bar_height) (mean(y(:, 1))+bar_height) (mean(y(:, 1))+bar_height) (mean(y(:, 1))-bar_height)], ...
    [(mean(y(:, 2))-bar_height) (mean(y(:, 2))+bar_height) (mean(y(:, 2))+bar_height) (mean(y(:, 2))-bar_height)]},...
    'alpha', 0.4);
g.geom_line(); g.geom_point();


g.set_names('x',xlbl,'y',ylbl); 
g.set_title(strcat(ttl,['[n = ' num2str(n) ', p = ' num2str(p,'%0.2e') ']']), 'FontSize', 12);

% g.axe_property('TickDir', 'out', 'YLim', [0 1.4]);
g.axe_property('TickDir', 'out', 'YLim', [0 1]);

g.set_color_options('map', color);
g.set_order_options('x', 0);
g.set_point_options('base_size', 5,'step_size', 0.5);
g.set_line_options('base_size', 0.05, 'step_size', 0.05); 
g.set_text_options('base_size', 12);
% g.geom_hline('yintercept', 0,'style', 'k--');

figure('Position',[100 100 400 500]);
g.draw();

g.export('file_name', sprintf('%s%s', output_folder, savename), 'file_type', 'jpg');
print(gcf, '-dpdf', sprintf('%s%s.pdf', output_folder, savename));

clear g; close;

end

