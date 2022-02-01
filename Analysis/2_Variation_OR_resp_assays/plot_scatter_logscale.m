function plot_scatter_logscale(x, y, color, ttl, xlbl, ylbl, savename, output_folder)

clear g
figure('Position',[50 50 550 550]);

%Create data for scatter plots
x0 = x(y == 0); y0 = y(y == 0);
x1 = x(y ~= 0); y1 = y(y ~= 0);

% axis limit
x_min = min(x); x_max = max(x);

%Create a scatter plot with zero
g(1,1)=gramm('x',x0,'y',y0);
g(1,1).geom_point('alpha', 0.1);  %Scatter plot
g(1,1).set_names('x',xlbl,'y',' ');
g(1,1).set_point_options('base_size',5);
g(1,1).set_layout_options('Position',[0 0.05 1 0.18], 'redraw', false, 'margin_height',[0.2 0.02],'margin_width',[0.1 0.02]);
g(1,1).axe_property('Ygrid','on', 'YLim', [-0.5 0.5], 'YTick', 0);

%Create a scatter plot
g(2,1)=gramm('x',x1,'y',y1);
g(2,1).geom_point('alpha', 0.1);  %Scatter plot
g(2,1).set_names('x','','y',ylbl);
g(2,1).set_point_options('base_size',5);
g(2,1).set_layout_options('Position',[0 0.2 1 0.8], 'redraw', false, 'margin_height',[0.05 0.05],'margin_width',[0.1 0.02]);
g(2,1).axe_property('Ygrid','on', 'YScale', 'log','YLim', [1 1e4], 'XTickLabel', {});

%Set global axe properties
g.axe_property('TickDir','out','XGrid', 'on', 'GridColor',[0.5 0.5 0.5], 'XLim', [(x_min-10) (x_max+10)]);
g.set_title(ttl);
g.set_color_options('map',color);

g.draw();
g(2).facet_axes_handles.XAxis.Visible = 'off';

print(gcf, '-dpdf', sprintf('%s%s.pdf', output_folder, savename));
g.export('file_name', sprintf('%s%s', output_folder, savename), 'file_type', 'jpg');

close;
end

