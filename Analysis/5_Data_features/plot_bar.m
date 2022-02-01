function plot_bar(x, y, color, ttl, xlbl, ylbl, savename, output_folder)
set(0,'defaultTextInterpreter','latex');

g=gramm('x', x(:),'y', y(:));
g.geom_label('color','k','dodge',0.7,'VerticalAlignment','bottom','HorizontalAlignment','center');
g.set_names('x',xlbl,'y',ylbl);

% [~,I] = sort(mean(y,2), 'descend'); sort_data = x(I, 1);
% g.set_order_options('x', sort_data);

g.set_order_options('x', x);
g.geom_hline('yintercept', 0,'style', 'k--');
g.stat_summary('geom',{'bar','black_errorbar'}, 'type', 'sem');

if strcmp(class(x), 'categorical')
    g.axe_property('XTickLabelRotation', 45, 'TickDir','out');
else
    g.axe_property('TickDir','out');
end

g.set_title(ttl);
g.set_color_options('map', color)
g.set_text_options('base_size', 14)

figure('Position', [0 0 1100 400] + 100)
g.draw();

g.export('file_name', sprintf('%s%s', output_folder, savename), 'file_type', 'jpg');
print(gcf, '-dpdf', sprintf('%s%s.pdf', output_folder, savename));
close;

end

