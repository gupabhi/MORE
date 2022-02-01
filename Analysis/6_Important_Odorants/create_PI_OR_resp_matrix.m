function out = create_PI_OR_resp_matrix(data_behvr,data_OR)

cols = [unique(data_OR.or)' 'response' 'concentration', 'assay']; 
cols_to_match = {'odor', 'concentration_type', 'species'};

output_same_conc = array2table(NaN(size(data_behvr,1),size(cols,2)), 'VariableNames',cols);  
output_conc_range = array2table(NaN(size(data_behvr,1),size(cols,2)), 'VariableNames',cols);
output_closest_conc = array2table(NaN(size(data_behvr,1),size(cols,2)), 'VariableNames',cols);

output_same_conc.assay = string(output_same_conc.assay);
output_conc_range.assay = string(output_conc_range.assay);
output_closest_conc.assay = string(output_closest_conc.assay);

for i = 1:size(data_behvr,1)
    subdata = data_OR(ismember(data_OR(:,cols_to_match),data_behvr(i,cols_to_match),'rows'), :);

    % get closest concentration
    [~, idx] = min(abs(log10(subdata{:,'concentration'}) - log10(data_behvr{i,'concentration'})));
    closest_conc = subdata{idx,'concentration'};
    subdata = subdata(subdata.concentration == closest_conc, :);
    [~, ia, ib] = intersect(cols, subdata.or);
    
    % for same concentration
    if (closest_conc == data_behvr{i,'concentration'})
        output_same_conc.odor(i,1) = data_behvr.odor(i,1); 
        output_same_conc.concentration(i,1) = data_behvr.concentration(i,1); 
        output_same_conc.response(i,1) = data_behvr.response(i,1);
        output_same_conc.assay(i,1) =  string(data_behvr.assay(i,1));
        output_same_conc(i, ia) = array2table(subdata.response(ib)');
    end
    
    % for concentration range
    % Note: taking 0.099 because, puting 0.1 won't include 0.1, as floating 
    %           point numbers can not be represented exactly in binary form
    if (closest_conc/data_behvr{i,'concentration'} <= 10.001) && ...
                    (closest_conc/data_behvr{i,'concentration'} >= 0.099) 
        
        output_conc_range.odor(i,1) = data_behvr.odor(i,1); 
        output_conc_range.concentration(i,1) = data_behvr.concentration(i,1);       
        output_conc_range.response(i,1) = data_behvr.response(i,1);   
        output_conc_range.assay(i,1) =  string(data_behvr.assay(i,1));
        output_conc_range(i, ia) = array2table(subdata.response(ib)');
    end
    
    % for closest concentration
    output_closest_conc.odor(i,1) = data_behvr.odor(i,1); 
    output_closest_conc.concentration(i,1) = data_behvr.concentration(i,1);       
    output_closest_conc.response(i,1) = data_behvr.response(i,1);   
    output_closest_conc.assay(i,1) = string(data_behvr.assay(i,1));
    output_closest_conc(i, ia) = array2table(subdata.response(ib)');
end

out.same_conc = output_same_conc; 
out.conc_range = output_conc_range; 
out.closest_conc = output_closest_conc;

% remove rows with all OR values as NaNs
fields = fieldnames(out);
for i = 1:size(fields,1)
    d = out.(fields{i}); or_data = table2array(d(:,2:end-2)); 
    d(sum(isnan(or_data), 2) == size(or_data,2), :) = []; out.(fields{i}) = d; 
end

end

