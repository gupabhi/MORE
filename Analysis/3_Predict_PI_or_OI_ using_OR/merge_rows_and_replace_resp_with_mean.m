function out_data = merge_rows_and_replace_resp_with_mean(data, cols_to_match, resp_col, ref_col, assay_col)

out_data = table;
unique_rows = unique(data(:,cols_to_match));
for i = 1:size(unique_rows,1)
    subdata = data(ismember(data(:,cols_to_match),unique_rows(i,:),'rows'), :);
    
    row = subdata(1,:);
    if (size(subdata,1) > 1)
        row{1,resp_col} = mean(subdata{:,resp_col}); 
        row{1,ref_col} = {strjoin(subdata{:,ref_col},', ')};
        
        if exist('assay_col','var')
            row{1,assay_col} = {strjoin(subdata{:,assay_col},', ')};
        end
    end
    out_data = vertcat(out_data, row(1,:));
    
end

end

