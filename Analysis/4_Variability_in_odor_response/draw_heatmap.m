function draw_heatmap(predictor_index_door, text_door, output_folder)

t = 1;
for i = 1:size(predictor_index_door, 1)      
    if size(find(predictor_index_door(i,:) == 100),2) == size(predictor_index_door,2) 
        row_index(1,t) = i;
        t = t+1;
    end
end
predictor_index_door(row_index, :) = [];    % removing rows with all values = 100

max_scale_door = max(abs(predictor_index_door(predictor_index_door ~= 100)));

 map_type_door = [ones(round(max_scale_door)+10, 1) linspace(0,1,round(max_scale_door)+10)' linspace(0,1,round(max_scale_door)+10)'; ...
               linspace(1,0,round(max_scale_door)+10)' linspace(1,0,round(max_scale_door)+10)' ones(round(max_scale_door)+10, 1)];
     
%% 
for i=1:size(predictor_index_door, 2)
    col = predictor_index_door(:,i);
    door_xmean_pred_index(1,i) = mean(col(col ~= 100));   % take mean along columns, get vector to plot in x direction
end
for i=1:size(predictor_index_door, 1)
    row = predictor_index_door(i,:);
    door_ymean_pred_index(1,i) = mean(row(row ~= 100));   % take mean along columns, get vector to plot in x direction
end

predictor_index_door(predictor_index_door == 100) = NaN;


%% DoOR-DMel
figure('Position', [5 5 300 980])
%% bargraph 1
sub_hndl = subplot(14, 5, [1:3 6:8]);
numPoints = size(door_xmean_pred_index, 2);
xValues = 1 : numPoints;
yValues = door_xmean_pred_index;

bar(sub_hndl, xValues, yValues, 0.9, 'FaceColor', [.7 .7 .7], 'EdgeColor', 'none');
xlim([0 numPoints+1])
% ylim([(min(yValues)-1) (max(yValues)+2)])
% ylim([(min(yValues)) (max(yValues))])
set(sub_hndl,'Box','off')
set(sub_hndl,'XColor','none')
% set(gca, 'YTick', [-8 -4 0 4]);
set(gca,'TickDir','out');

colorTitleHandle = get(sub_hndl,'Title');
set(colorTitleHandle ,'String',text_door, 'Interpreter','none');

%% colormap
sub_hndl = subplot(14, 5, [11:5:66 12:5:67 13:5:58]);
colormap(map_type_door);
imagesc(sub_hndl, predictor_index_door, 'AlphaData',~isnan(predictor_index_door));
set(sub_hndl, 'YDir', 'normal', 'Color', [0.8 0.8 0.8]);
caxis(sub_hndl, [-max_scale_door max_scale_door])
xlabel(sub_hndl, 'Odorant receptors (DoOR)') 
xlim([0 numPoints+1])
set(gca,'TickDir','out');
sub_hndl = subplot(14, 5, [4:5 9:10]);
sub_hndl.YAxis.Visible = 'off';
sub_hndl.XAxis.Visible = 'off';
sub_hndl.Color = 'none';
caxis(sub_hndl, [-max_scale_door max_scale_door])
colorbar(sub_hndl, 'Location', 'westoutside')

%% bargraph 2
sub_hndl = subplot(14, 5, [14:5:69 15:5:70]);
numPoints = size(door_ymean_pred_index, 2);
xValues = 1 : numPoints;
yValues = door_ymean_pred_index;

barh(sub_hndl, xValues, yValues, 0.9, 'FaceColor', [.7 .7 .7], 'EdgeColor', 'none');
ylim([0 numPoints+1])
% xlim([(min(yValues)-1) (max(yValues)+1)])
% xlim([(min(yValues)) (max(yValues))])
set(sub_hndl,'Box','off')
set(sub_hndl,'YColor','none')
% set(gca, 'XTick', [-8 -4 0 4])
set(gca,'TickDir','out');

saveas(sub_hndl,sprintf('%s%s', output_folder, text_door),'pdf')
saveas(sub_hndl,sprintf('%s%s', output_folder, text_door),'png')
end

