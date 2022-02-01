function plot_odor_response_with_pairwise_assays(data_behvr_specie, color, output_folder)

specie = unique(data_behvr_specie.specie);
%% round off concentration to nearest concentration interger
data_behvr_specie.concentration = round(log10(data_behvr_specie.concentration));

assays = unique(data_behvr_specie.assay);
assay_combinations = nchoosek(assays,2);

for i = 1:size(assay_combinations,1)
    assay1_data = data_behvr_specie(strcmp(data_behvr_specie.assay, assay_combinations(i,1)), :);
    assay2_data = data_behvr_specie(strcmp(data_behvr_specie.assay, assay_combinations(i,2)), :);

    assay1_odors = unique(assay1_data.odor); assay2_odors = unique(assay2_data.odor);
    common_odors = intersect(assay1_odors, assay2_odors);
    
    if size(common_odors, 1) > 0
        mat_assay = array2table(zeros(0,2)); mat_odor = array2table(zeros(0,2));
        mat_conc = array2table(zeros(0,2)); mat_resp = array2table(zeros(0,2)); 
        mat_ref = array2table(zeros(0,2));

        for j = 23:size(common_odors,1)
            assay1_odor_data = assay1_data(strcmp(assay1_data.odor, common_odors(j)), :);
            assay2_odor_data = assay2_data(strcmp(assay2_data.odor, common_odors(j)), :);
            
            assay1_odor_data = merge_same_concentration_datapoints(assay1_odor_data);
            assay2_odor_data = merge_same_concentration_datapoints(assay2_odor_data);
            
            common_concs = intersect(assay1_odor_data.concentration, assay2_odor_data.concentration);
            if size(common_concs, 2) > 0
                for k = 1:size(common_concs,1)
                    assay1_odor_conc_data = assay1_odor_data(assay1_odor_data.concentration == common_concs(k), :);
                    assay2_odor_conc_data = assay2_odor_data(assay2_odor_data.concentration == common_concs(k), :);
                    
                    mat_assay = [mat_assay; {assay1_odor_conc_data.assay, assay2_odor_conc_data.assay}];
                    mat_odor = [mat_odor; {assay1_odor_conc_data.odor, assay2_odor_conc_data.odor}];
                    mat_conc = [mat_conc; {assay1_odor_conc_data.concentration, assay2_odor_conc_data.concentration}];
                    mat_resp = [mat_resp; {assay1_odor_conc_data.response, assay2_odor_conc_data.response}];
                    mat_ref = [mat_ref; {assay1_odor_conc_data.reference, assay2_odor_conc_data.reference}];
                end
            end
        end
        
        x = table2array(mat_conc); y = table2array(mat_resp); z = table2array(mat_assay); o = table2array(mat_odor);
        
        if size(x,1) > 1
            ttl = strcat(unique(specie),'_', assay_combinations(i,1), '_', assay_combinations(i,2)); 
            xlbl = 'Assays'; ylbl = 'Preference Index'; savename = ttl;
            plot_pairwise_assay_paired_comparison(x, y, z, o, ttl{1}, xlbl, ylbl, color, savename{1}, output_folder);
        end
    end
end

end

