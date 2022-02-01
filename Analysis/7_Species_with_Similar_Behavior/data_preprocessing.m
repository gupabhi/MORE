% input: table with all categorical variables converted to string
function [output] = data_preprocessing(data)

%% make all strings with lowercase
for i = 1:size(data,2)
    if isa(data{:,1}, 'string')
        data{:,i} = lower(data{:,i});
    end
end

%% remove rows with NaN, except if concentration_type is dry then make it 1 (100% concentration)
rmv_idx = []; 
nan_idx = find(sum(ismissing(data),2)>0);

for i = 1:size(nan_idx, 1)
   if ~strcmp(data{nan_idx(i), 'concentration_type'},'dry')
       rmv_idx = [rmv_idx, nan_idx(i)];
   else
       data{nan_idx(i), 'concentration'} = 1;
   end
end

data(rmv_idx, :) = [];

%% remove rows with NA
data = remove_rows(data, 'NA');

output = data;
end

