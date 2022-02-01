% input: table with all categorical variables converted to string
function [output] = data_preprocessing(data)

%% make all strings with lowercase
for i = 1:size(data,2)
    if iscellstr(data{:,i})
        data{:,i} = lower(data{:,i});
    end
end

%% remove rows with NaN except if concentration_type is dry
data((sum(ismissing(data),2)>0), :) = [];

%% remove rows with NA
data = remove_rows(data, 'NA');

output = data;

end

