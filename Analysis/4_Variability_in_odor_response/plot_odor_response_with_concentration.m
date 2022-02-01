function plot_odor_response_with_concentration(data_behvr_specie, color, savename, output_folder)

%% plot violin of preference index Vs odor concentration
species = unique(data_behvr_specie.species);

out_data = array2table(zeros(0,size(data_behvr_specie.Properties.VariableNames,2)));
out_data.Properties.VariableNames = data_behvr_specie.Properties.VariableNames;

data_behvr_specie.concentration = round(log10(data_behvr_specie.concentration));

odors = unique(data_behvr_specie.odor);
for i = 1:size(odors,1)
    odor_data = data_behvr_specie(strcmp(data_behvr_specie.odor, odors(i)),:);
    concs = unique(odor_data.concentration);
    
    % plot for more than 1 concentration
    if (size(concs, 1) > 3)             
        [concs_count,~] = hist(odor_data.concentration,unique(odor_data.concentration));
        
        % plot only when at least 2 datapoint for each concentration is available
        if ~(sum(concs_count  < 2) > 0)     
            for j = 1:size(concs,1)
                conc_data = odor_data(ismember(odor_data.concentration, concs(j)),:);
                out_data = [out_data; conc_data];
            end
            
            % dose-response relationship violin plot 
            x = out_data(strcmp(out_data.odor, odors(i)),:).concentration;
            y = out_data(strcmp(out_data.odor, odors(i)),:).response;
            
            ttl = strcat(species,'_',odors(i), '_', savename);
            xlbl = 'log(concentration)'; ylbl = 'Preference Index'; 
            if strcmp(odors(i), 'benzaldehyde') && strcmp(savename, 't-maze')
                bandwidth = 0.1;
            elseif strcmp(odors(i), 'ethanol') && strcmp(savename, 'y-maze')
                bandwidth = 0.2;
            else
                bandwidth = 0.2;
            end
            plot_violin(x, y, ttl, xlbl, ylbl, color, bandwidth, output_folder)
        
        end
    end
end

end

