function plot_scatter_btw_propty_pair(data_odor_prop, color, output_folder)
% input: data_odor_prop -- table with 1st col = odor; 2:end cols = props_to_plot;
% output: scatter plot between pair of properties for the same set of odorants

num_prop = size(data_odor_prop, 2) - 1;   % subtracting the odor col
props = data_odor_prop.Properties.VariableNames(2:end);
pair_props = combnk(props, 2);

mat_corr = array2table(zeros(0,3));
mat_corr.Properties.VariableNames = {'prop1', 'prop2', 'corr'};

for i = 1:size(pair_props, 1)
    prop1 = pair_props(i,1); 
    prop2 = pair_props(i,2);
    
    x = data_odor_prop(:, prop1); 
    y = data_odor_prop(:, prop2);
    
    % find idx with double datatype
    dataType_x = cellfun(@(x) class(x), table2cell(x), 'UniformOutput',false);
    dataType_y = cellfun(@(y) class(y), table2cell(y), 'UniformOutput',false);
    
    idx_double = unique([find(contains(dataType_x, 'double')); ...
        find(contains(dataType_y, 'double'))]);
    
    x = x(idx_double, :); 
    y = y(idx_double, :);
    
    if (size(x,1) > 0) && (size(y,1) > 0)
        
        % find indx with empty prop value
        idx_nonEmpty = setdiff(1:size(x,1), unique([find(cellfun(@isempty,table2array(x))); ...
            find(cellfun(@isempty,table2array(y)))]));

        x = x(idx_nonEmpty, :); 
        y = y(idx_nonEmpty, :);
    
        if (size(x,1) > 0) && (size(y,1) > 0)
            
            % find indx with empty prop value
            idx_nonNaN = setdiff(1:size(x,1), unique([find(cellfun(@isnan, table2array(x))); ...
                find(cellfun(@isnan, table2array(y)))]));

            x = x(idx_nonNaN, :); 
            y = y(idx_nonNaN, :);

            if (size(x,1) > 0) && (size(y,1) > 0)
                
                % find if any cell is of char datatype
                idx_nonChar = setdiff(1:size(x,1), unique([find(cellfun(@ischar,table2array(x))); ...
                    find(cellfun(@ischar,table2array(y)))]));

                x = x(idx_nonChar, :); 
                y = y(idx_nonChar, :);
                
                if (size(x,1) > 0) && (size(y,1) > 0)
                
                    fprintf('Plotting - %s and %s\n', prop1{1}, prop2{1});

                    % plot scatter
                    ttl = ''; xlbl = prop1; ylbl = prop2;
                    savename = strcat('scatter_', prop1{1}, prop2{1});
                    
                    x = cell2mat(table2array(x));
                    y = cell2mat(table2array(y));

                    [r_value,~] = corrcoef(x,y); 
                    
                    mat_corr = [mat_corr; {prop1{1}, prop2{1}, r_value(1,2)}];
                    mat_corr = [mat_corr; {prop2{1}, prop1{1}, r_value(1,2)}];
                    

%                     plot_scatter2(x, y, ...
%                         color, ttl, xlbl, ylbl, savename, output_folder);  
            

                else
                    fprintf('No data to plot for %s and %s\n', prop1, prop2);
                end
            else
                fprintf('No data to plot for %s and %s\n', prop1, prop2);
            end
        else
            fprintf('No data to plot for %s and %s\n', prop1, prop2);
        end
    else
        fprintf('No data to plot for %s and %s\n', prop1, prop2);
    end
   
end


%% create heatmap matrix
for i = 1:size(props,2)
    mat_corr = [mat_corr; {props(1,i), props(1,i), 1}];
end


mat = zeros(size(props,2), size(props,2));
for i = 1:size(props,2)
   for j = 1:size(props,2)
       p1 = props(1,i); p2 = props(1,j); 
       corr_idx = and(contains(mat_corr.prop1, p1), contains(mat_corr.prop2, p2));
       mat(i,j) = mat_corr.corr(corr_idx,1);
   end
end


max_scale = max(mat(:));   

map = [ones(round(max_scale)+10, 1) linspace(0,1,round(max_scale)+10)' linspace(0,1,round(max_scale)+10)'; ...
               linspace(1,0,round(max_scale)+10)' linspace(1,0,round(max_scale)+10)' ones(round(max_scale)+10, 1)];
          

m = heatmap(props, props, mat, 'Colormap', map);
hFig = gcf;
caxis(m, [-1 1]);

saveas(hFig,strcat(output_folder, 'heatmap_corr_pair_props'),'pdf');

close;

end

