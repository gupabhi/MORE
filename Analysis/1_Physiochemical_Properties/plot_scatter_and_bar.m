function plot_scatter_and_bar(x, y, color, ttl, xlbl, ylbl, xlim, ylim, savename, output_folder)

clear g;
figure('Position',[50 50 550 550]);

nbins = 20;

%% get p-value and n
numTrials = 1000;
[p, actualSigma, actualFit] = calculate_pvalue(x, y, numTrials);
n = size(x,1);

%% Create x data histogram on top
% g(1,1)=gramm('x',x);
% g(1,1).set_layout_options('Position',[0 0.8 1 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
%     'legend',false,... % No need to display legend for side histograms
%     'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
%     'margin_width',[0.1 0.02]); %We deactivate automatic redrawing/resizing so that the axes stay aligned according to the margin options
% g(1,1).set_names('x', '', 'y', 'Count');
% g(1,1).stat_bin('geom','stacked_bar','fill','all','nbins',nbins); %histogram
% g(1,1).axe_property('XTickLabel',''); % We deactivate tht ticks

%% Create a scatter plot
g(2,1)=gramm('x',x,'y',y);
g(2,1).geom_point('alpha', 0.1);  %Scatter plot
g(2,1).stat_fit('fun', actualFit, 'geom', 'line', 'fullrange','true');
% g(2,1).stat_summary('type', 'ci', 'geom', 'point', 'bin_in', nbins);
g(2,1).set_names('x',xlbl,'y',ylbl, 'color', '');
g(2,1).set_point_options('base_size',5);
g(2,1).set_layout_options('Position',[0 0 1 1], 'legend_pos',[0.83 0.75 0.2 0.2],... 
    'margin_height',[0.1 0.02],'margin_width',[0.1 0.02]); %We detach the legend from the plot and move it to the top right
g(2,1).axe_property('Ygrid','on');

%% Create y data histogram on the right
% g(3,1)=gramm('x',y);
% g(3,1).set_layout_options('Position',[0.8 0 0.2 0.8],...
%     'legend',false,...
%     'margin_height',[0.1 0.02],...
%     'margin_width',[0.02 0.05]);
% g(3,1).set_names('x', '', 'y', 'Count');
% g(3,1).stat_bin('geom','stacked_bar','fill','all','nbins',nbins); %histogram
% g(3,1).coord_flip();
% g(3,1).axe_property('XTickLabel','');

%% Set global axe properties
g.axe_property('TickDir','out','XGrid','on','GridColor',[0.5 0.5 0.5], 'YLim', ylim, 'XLim', xlim);
g.set_title(ttl); 
g.set_color_options('map',[color; [0 0 0]]);
g.set_text_options('base_size', 15);
g.set_title(strcat(' [p= ', num2str(p), ', n= ', num2str(n), ', sigma= ',...
    num2str(actualSigma), ', numTrials= ', num2str(numTrials), ']'), 'FontSize', 12);

g.draw();

g(2,1).results.stat_fit.line_handle.Color = [0 0 0];

print(gcf, '-dpdf', sprintf('%s%s.pdf', output_folder, savename));
g.export('file_name', sprintf('%s%s', output_folder, savename), 'file_type', 'jpg');

close;
end

