function corr_pi_oi(data_pi, data_oi, color, output_folder)

format longg;

%% data initialization & preprocessing
data_pi = data_preprocessing(data_pi(:, {'odor', 'concentration', 'concentration_type', ...
                'species', 'reference', 'response'})); 

data_oi = data_preprocessing(data_oi(:, {'odor', 'concentration', 'concentration_type', ...
                'species', 'reference', 'response'}));

%% find common rows between two datasets
exact_match_cols = {'odor', 'concentration_type', 'species'};
common_species = intersect(unique(data_pi.species),unique(data_oi.species));

% round off concentration to nearest folds of 10
data_pi.concentration = 10.^round(log10(data_pi.concentration)); 
data_oi.concentration = 10.^round(log10(data_oi.concentration)); 

mat = struct; 
mat.odor = cell2table(cell(0,2)); mat.resp = cell2table(cell(0,2)); 
mat.conc = cell2table(cell(0,2)); mat.species = cell2table(cell(0,2));
    
for i = 1:size(common_species,1)

    disp(common_species(i));
    % get data for a common species in both the datasets
    data_pi_species = data_pi(strcmp(data_pi.species, common_species(i)),:);   
    data_oi_species = data_oi(strcmp(data_oi.species, common_species(i)),:);

    % find common rows in the PI and OI datasets
    common_rows = intersect(data_pi_species(:,exact_match_cols), data_oi_species(:,exact_match_cols));
    data_pi_species = data_pi_species(ismember(data_pi_species(:,exact_match_cols),common_rows,'rows'), :);
    data_oi_species = data_oi_species(ismember(data_oi_species(:,exact_match_cols),common_rows,'rows'),:);
    
    % merge duplicate rows in the dataset; replacing response with means
    data_pi_species = merge_rows_and_replace_resp_with_mean(data_pi_species, ...
            {'odor', 'concentration_type', 'concentration', 'species'},'response', 'reference');
    data_oi_species = merge_rows_and_replace_resp_with_mean(data_oi_species, ...
            {'odor', 'concentration_type', 'concentration', 'species'},'response', 'reference');

    mat_pi_oi = create_pi_oi(data_pi_species, data_oi_species);
    
    mat.odor = [mat.odor; mat_pi_oi.odor]; mat.resp = [mat.resp; mat_pi_oi.resp];
    mat.conc = [mat.conc; mat_pi_oi.conc]; mat.species = [mat.species; mat_pi_oi.species];

    %  plot for each species 
    ttl = common_species(i); 
    xlbl = 'Preference Index'; 
    ylbl = 'Oviposition Index';
    savename = strcat('corr_pi_oi_', common_species(i));
    
    str_odor = capatalize_first_letter(table2array(mat_pi_oi.odor(:,1)));
    str_pi_conc = strcat(string(table2array(mat_pi_oi.conc(:,1))*100), '%');
    str_oi_conc = strcat(string(table2array(mat_pi_oi.conc(:,2))*100), '%');
    
    txt = strcat(str_odor, ',', ' ', str_pi_conc, ',', ' ', str_oi_conc);
    
    x = table2array(mat_pi_oi.resp(:,1)); 
    y = table2array(mat_pi_oi.resp(:,2)); 
    
    if size(x,1) > 1
        plot_scatter(x, y, color, ttl, xlbl, ylbl, savename, output_folder, 0, txt)
    end
    
end

% plot for all species together
% if size(mat_pi_oi.resp,1) > 0
%     % scatter plot
%     ttl = strjoin(common_species, '_'); xlbl = 'Preference Index'; ylbl = 'Oviposition Index';
%     savename = strcat('corr_pi_oi_', strjoin(common_species, '_'));
%     txt  = table2array(mat.odor(:,1));
%     x = table2array(mat.resp(:,1)); y = table2array(mat.resp(:,2));
%     plot_scatter(x, y, color, ttl, xlbl, ylbl, savename, output_folder, 0, txt)
% end

end

