function str = capatalize_first_letter(str)
% Input - string array
% Output - Capatalize first letter of string array elements

for i=1:size(str,1)
    str{i}(1) = upper(str{i}(1));
end

end

