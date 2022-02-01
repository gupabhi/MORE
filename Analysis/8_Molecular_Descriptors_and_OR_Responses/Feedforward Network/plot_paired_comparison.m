function plot_paired_comparison(x, y, z, ttl, xlbl, ylbl, color, savename, output_folder)

p =signrank(y(:,1), y(:,2));   % p-value 

g=gramm('x', cellstr(x(:)),'y', y(:), 'group', z(:));

%  get horizontal line at mean
% bar_width = 0.2;
% bar_height = 0.01;
bar_width = 0.2;
bar_height = 0.5;

% draw line and points
g.geom_line(); g.geom_point('alpha', 0.4);
g.geom_polygon('x', {1+[-1 -1 1 1]*bar_width, 2+[-1 -1 1 1]*bar_width}, 'y', ...
    {[(mean(y(:, 1))-bar_height) (mean(y(:, 1))+bar_height) (mean(y(:, 1))+bar_height) (mean(y(:, 1))-bar_height)], ...
    [(mean(y(:, 2))-bar_height) (mean(y(:, 2))+bar_height) (mean(y(:, 2))+bar_height) (mean(y(:, 2))-bar_height)]},...
    'alpha', 0.4);


% set text parameters
g.set_names('x',xlbl,'y',ylbl); 
g.set_title(strcat(ttl, ' [p = ', num2str(p), ', n = ', num2str(size(y,1)), ']'), 'FontSize', 15);

g.axe_property('TickDir', 'out');
g.set_color_options('map', color);
g.set_order_options('x', 0);
g.set_point_options('base_size', 15);
g.set_line_options('base_size', 0.15); 

% draw the figure
figure('Position',[100 100 800 800]);
g.set_text_options('base_size', 24, 'legend_title_scaling', 1);
g.geom_hline('yintercept', 0,'style', 'k--');
g.draw();

% save the figure
saveas(gcf, sprintf('%s%s%s', output_folder, savename, '.png'));
saveas(gcf, sprintf('%s%s%s', output_folder, savename, '.pdf'));

clear g; close;


end

