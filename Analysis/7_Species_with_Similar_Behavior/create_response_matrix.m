function out = create_response_matrix(data_behvr1,data_behvr2)
% Give two species behavioral data find out the common odors between their dataset

% initialize some variables
cols_to_match = {'odor', 'concentration_type'};

% find common rows in the behvr and OR datasets
common_rows = intersect(data_behvr1(:,cols_to_match), data_behvr2(:,cols_to_match));
common_data_behvr1 = data_behvr1(ismember(data_behvr1(:,cols_to_match),common_rows,'rows'), :);
common_data_behvr2 = data_behvr2(ismember(data_behvr2(:,cols_to_match),common_rows,'rows'),:);
    
% merge duplicate rows in the dataset; replacing response with means
compressed_data_behvr1 = merge_rows_and_replace_resp_with_mean(common_data_behvr1, ...
        {'odor', 'concentration_type', 'concentration'},'response', 'reference', 'assay');
compressed_data_behvr2 = merge_rows_and_replace_resp_with_mean(common_data_behvr2, ...
        {'odor', 'concentration_type', 'concentration'},'response', 'reference','assay');

% for simplicity
db1 = compressed_data_behvr1; 
db2 = compressed_data_behvr2;

% initialize output variables
output_same_conc = [];
output_conc_range = [];
output_closest_conc = [];

for i = 1:size(db1, 1)
    subdata = db2(ismember(db2(:,cols_to_match),db1(i,cols_to_match),'rows'), :);

    % get closest concentration
    [~, idx] = min(abs(log10(subdata{:,'concentration'}) - log10(db1{i,'concentration'})));
    closest_conc = subdata{idx,'concentration'};
    subdata = subdata(subdata.concentration == closest_conc, :);
    
    % change col names to concat both common rows between the two dataset
    row1 = db1(i,:);
    row2 = subdata;
    row1.Properties.VariableNames = cellstr(strcat(string(row1.Properties.VariableNames), '1'));
    row2.Properties.VariableNames = cellstr(strcat(string(row2.Properties.VariableNames), '2'));
    
    % for same concentration
    if (closest_conc == db1{i,'concentration'})
        output_same_conc = [output_same_conc; [row1 row2]]; 
    end
    
    % for concentration range
    % Note: taking 0.099 because, puting 0.1 won't include 0.1, as floating 
    %           point numbers can not be represented exactly in binary form
    if (closest_conc/db1{i,'concentration'} <= 10.001) && ...
                    (closest_conc/db1{i,'concentration'} >= 0.099) 
        
        output_conc_range = [output_conc_range; [row1 row2]];
    end
    
     % for closest concentration
     output_closest_conc = [output_conc_range; [row1 row2]];
end


out.same_conc = output_same_conc; 
out.conc_range = output_conc_range; 
out.closest_conc = output_closest_conc;

end

