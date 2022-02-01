function Odors_descriptors = create_descriptor_odor_matrix(filepath, OR_responses, output_folder)

% % read descriptor data from the file
% Odor_Descriptors = readtable(filepath);
% writetable(Odor_Descriptors,strcat(output_folder, 'Odor_Descriptors.xlsx'));
% save(strcat(output_folder, 'Odor_Descriptors.mat'), 'Odor_Descriptors');
load(strcat(output_folder, 'Odor_Descriptors.mat'));

% initialize some variables
odors = OR_responses.Properties.VariableNames;
num_odors = size(odors, 2);
num_descriptors = size(Odor_Descriptors,2)-5;


% initialize output table/matrix
data_fields = cellstr(string(odors)');
Odors_descriptors  = array2table(NaN(num_descriptors,num_odors), 'VariableNames', data_fields);

for i = 1:num_odors
    odor = odors{i};
    odor_idx = find(strcmp(Odor_Descriptors.odor_sheet_name, odor));
    odor_descriptors = table2array(Odor_Descriptors(odor_idx, 6:end))'; % odor descriptors starts from 6th col
    
    out_idx = find(strcmp(Odors_descriptors.Properties.VariableNames, odor));
    Odors_descriptors(:, out_idx) = array2table(odor_descriptors);
end

end

