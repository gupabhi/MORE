function out = read_csv(filename)

r = readtable(filename, 'Delimiter',',');
out = r(1:end, :); 

end

