function plot_bar2(x, y, z, ttl, xlbl, ylbl, savename, output_folder)
set(0,'defaultTextInterpreter','latex');

g=gramm('x', x(:),'y', y(:), 'color', z(:));
% g.geom_bar('width', 0.7, 'dodge',0.8);
g.stat_summary('geom', {'bar'}, 'dodge', 0.92, 'width', 0.8);

g.set_order_options('x', 0);
g.geom_hline('yintercept', 0,'style', 'k--');


if strcmp(class(x), 'categorical')
    g.axe_property('XTickLabelRotation', 45, 'TickDir','out');
else
    g.axe_property('TickDir','out');
end      

g.set_title(ttl);
g.set_text_options('base_size', 16); 
g.set_layout_options('legend_position', [0.7 0.5 0.1 0.5]);
g.set_names('x',xlbl,'y',ylbl, 'color', 'Data Type', 'group', {'Behavioral', 'electrophysiology'});

figure('Position', [0 0 900 400] + 100)
g.draw();

g.export('file_name', sprintf('%s%s', output_folder, savename), 'file_type', 'jpg');
print(gcf, '-dpdf', sprintf('%s%s.pdf', output_folder, savename));
close;

end

