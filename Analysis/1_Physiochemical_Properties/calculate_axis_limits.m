function axisLimit = calculate_axis_limits(data1, data2, props_to_plot)
% given data1 and data2 containing response and properties value --
% calculate the x and y limit for graphs

axisLimit = struct;

% for responses
y = [data1.response; data2.response];

margin = 10^(numel(num2str(round(mean(y))))-1);
axisLimit.response = [(min(y) - margin) (max(y) + margin)];

for i = 1:size(props_to_plot, 2)
    prop = props_to_plot{i};

    x = [data1(:, prop); data2(:, prop)];

    % pass only datapoints with double cell datatype
    dataType = cellfun(@(x) class(x), table2cell(x), 'UniformOutput',false);
    x = x(contains(dataType, 'double'), :);

    if (size(x,1) > 0) 
        
        emptyLoc = cellfun('isempty', x{:,1}); % location of empty datapoint
        x(emptyLoc, :) = []; x = cell2mat(table2array(x)); 

        if (size(x,1) > 0) 
            
            nanLoc = isnan(x(:,1));     % remove entries with NaN
            x(nanLoc, :) = []; 

            if (size(x,1) > 0) 
                margin = (10^(numel(num2str(round(mean(x))))-1))/2;
                axisLimit.(prop) = [round(min(x) - margin) round(max(x) + margin)];
                              
            end
        end
    end
end

end

