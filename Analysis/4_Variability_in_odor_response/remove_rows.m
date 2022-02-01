% remove rows containing string str
function [output] = remove_rows(data, str)

for i = 1:size(data, 2)
    data(strcmp(data{:,i}, str), :) = [];
end
output = data;

end

