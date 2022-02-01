function plot_results(data, min_datapoints, color, output_folder)
% Given common data between species. Plot the correlation in their responses

pairs = fieldnames(data);
for i = 1:length(pairs)
    pair_data = data.(pairs{i});
    
    conc_criteria = fieldnames(pair_data);
    for j = 1:length(conc_criteria)
        conc_data = pair_data.(conc_criteria{j});
        
        % Plot only id the num_datapoints >= min_datapoints
        if size(conc_data,1) >= min_datapoints
            species1 = capatalize_first_letter(unique(conc_data.species1));
            species2 = capatalize_first_letter(unique(conc_data.species2));

            x = conc_data.response1;
            y = conc_data.response2;

            ttl = strcat(pairs{i}, '_', conc_criteria{j});
            xlbl = strcat('Preference Index -',{' '}, species1);
            ylbl = strcat('Preference Index - ',{' '}, species2);
            savename = strcat('scatter_plot_', ttl);

            plot_scatter(x, y, color.g, ttl, xlbl, ylbl, savename, output_folder, 0);
        end
    end
    
end

