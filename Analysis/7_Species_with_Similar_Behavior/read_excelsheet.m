function out = read_excelsheet(filename, sheetname, savename, output_folder)

r = readtable(filename, 'Sheet', sheetname);
out = r(2:end, :);

% define class of each column of table
out.odor = string(out.odor);
out.concentration_type = string(out.concentration_type);
out.species = string(out.species);
out.gender = string(out.gender);
out.reference = string(out.reference);

% save data
S.(savename) = out;
save(sprintf('%s%s.mat', output_folder, savename), '-struct', 'S');

end

