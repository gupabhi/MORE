% Input: data is a Struct; with three database same_conc, conc_range, closest_conc 
% -- in each table last 3 cols are response, concentration and odor
function out = replace_NaN_with_row_mean(data, nNaN_OR)

data_fields = fieldnames(data);
for i = 1:size(data_fields)
   subdata_fields = fieldnames(data.(data_fields{i})); 
   for j = 1:size(subdata_fields)
       mat = data.(data_fields{i}).(subdata_fields{j}); 
       mat(:, sum(isnan(table2array(mat(:,1:end-3))),1) > nNaN_OR(j)) = []; % apply OR column criteria
       mat(sum(isnan(table2array(mat(:,1:end-3))),2) > (size(mat(:,1:end-3),2)/2),:) = []; % if more than half OR are NaN then remove datapoint

       % if NaN still left then replace them with row mean
       for k = 1:size(mat,1)
          row = table2array(mat(k,1:end-3));
          row(isnan(row))= mean(row(~isnan(row)));
          mat(k,1:end-3) = array2table(row);
       end
       data.(data_fields{i}).(subdata_fields{j}) = mat;
   end
end
out = data;

end
