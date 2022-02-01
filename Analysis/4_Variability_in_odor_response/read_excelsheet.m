function out = read_excelsheet(filename, sheetname)

r = readtable(filename, 'Sheet', sheetname);
out = r(2:end, :); 

end

