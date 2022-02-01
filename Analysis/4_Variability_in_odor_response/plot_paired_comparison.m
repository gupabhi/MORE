function plot_paired_comparison(x, y, z, ttl, xlbl, ylbl, color, output_folder)

g=gramm('x', cellstr(z(:)),'y', y(:),'marker', x(:));
g.geom_line();
g.geom_point();

g.set_names('x',xlbl,'y',ylbl); g.set_title(ttl{1});
g.axe_property('TickDir', 'out', 'YLim', [-1 1]);
g.set_color_options('map', color);
% g.set_point_options('base_size', sizePoint);
g.draw();

g.export('file_name', sprintf('%s%s', output_folder, ttl{1}), 'file_type', 'jpg');
print(gcf, '-dpdf', sprintf('%s%s.pdf', output_folder, ttl{1}));

clear g; close;
end

