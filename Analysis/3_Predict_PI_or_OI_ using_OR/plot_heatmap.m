function plot_heatmap(mat, xvalues, yvalues, ttl, xlbl, ylbl, savename, output_folder)

figure('Position',[50 50 12*size(xvalues,2) 12*size(yvalues,2)]);

max_val = abs(max(mat(:)));
min_val = abs(min(mat(:)));

map_type = [ones(round(min_val)+10, 1) linspace(0,1,round(min_val)+10)' linspace(0,1,round(min_val)+10)'; ...
               linspace(1,0,round(max_val)+10)' linspace(1,0,round(max_val)+10)' ones(round(max_val)+10, 1)];

h = heatmap(xvalues,yvalues,mat);
h.Title = ttl; h.XLabel = xlbl; h.YLabel = ylbl;

colormap(map_type);
set(gca,'FontSize',6)

saveas(h,sprintf('%s%s', output_folder, savename),'pdf')
saveas(h,sprintf('%s%s', output_folder, savename),'png')

close;
end

