function out = create_OR_odor_response_matrix(data)
% Given the excel sheet data, create a matrix of OR-odor responses
% where rows -> ORs, cols - Odor

% get ORs and odors
ORs = unique(data.or); num_ORs = size(ORs,1);
odors = unique(data.odor); num_odors = size(odors,1);

% initialize output table/matrix
data_fields = cellstr(['OR'; string(odors)]');
out  = array2table(NaN(num_ORs,num_odors+1), 'VariableNames', data_fields);
out.OR = ORs;

% loop through the data
for i = 1:size(data,1)
    OR = data.or{i};
    Odor = data.odor{i};
    
    OR_idx = find(strcmp(out.OR, OR));
    Odor_idx = find(strcmp(out.Properties.VariableNames, Odor));
    
    out{OR_idx, Odor_idx} = data.response(i);
end

end

