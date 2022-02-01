% Plot graphs between different odor properties (prop) and odorant response(resp)
% Compatible for the dataset where OR response comes after num_nonOR_cols number of columns

function  resp_prop(data, props_to_plot, color, axisLimit, tag, output_folder)

for i = 1:size(props_to_plot, 2)
    prop = props_to_plot{i};

    x = data(:, prop); y = data.response;

    % pass only datapoints with double cell datatype
    dataType = cellfun(@(x) class(x), table2cell(x), 'UniformOutput',false);
    x = x(contains(dataType, 'double'), :); y = y(contains(dataType, 'double'), :);

    if (size(x,1) > 0) && (size(y,1) > 0)
        
        emptyLoc = cellfun('isempty', x{:,1}); % location of empty datapoint
        x(emptyLoc, :) = []; x = cell2mat(table2array(x)); y(emptyLoc,:) = [];

        if (size(x,1) > 0) && (size(y,1) > 0)
            
            nanLoc = isnan(x(:,1));     % remove entries with NaN
            x(nanLoc, :) = []; y(nanLoc,:) = [];

            if (size(x,1) > 0) && (size(y,1) > 0)
                fprintf('Plotting - %s\n', prop);
                
                ttl = ''; xlbl = prop; ylbl = 'Odorant Receptor Response (spikes/s)'; 
                savename = sprintf('scatter_resp_%s_%s', tag, prop);
                xlim = axisLimit.(prop); ylim = axisLimit.response;
                plot_scatter_and_bar(x, y, color, ttl, xlbl, ylbl, xlim, ylim, savename, output_folder)
                
%                 plot_actual_shuffle_gaussian_fit(x, y, 100, unique(data.species), prop, output_folder);                
            else
                fprintf('No data to plot for %s\n', prop);
            end
        else
            fprintf('No data to plot for %s\n', prop);
        end
    else
        fprintf('No data to plot for %s\n', prop);
    end
end

end

