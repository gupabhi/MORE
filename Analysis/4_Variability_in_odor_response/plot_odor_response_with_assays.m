function plot_odor_response_with_assays(data_behvr_specie, color, output_folder)

%% round off concentration to nearest concentration interger
data_behvr_specie.concentration = round(log10(data_behvr_specie.concentration));

%% for each odor check responses among different assays
odors = unique(data_behvr_specie.odor);
for i = 1:size(odors,1)
    out_data = array2table(zeros(0,size(data_behvr_specie.Properties.VariableNames,2)));
    out_data.Properties.VariableNames = data_behvr_specie.Properties.VariableNames;
    odor_data = data_behvr_specie(strcmp(data_behvr_specie.odor, odors(i)),:);
    
    if size(odor_data,1) > 1
        assays = unique(odor_data.assay);
        
        if size(assays,1) > 1
            for j = 1:size(assays,1)
                assay_data = odor_data(strcmp(odor_data.assay, assays(j)),:);
                
                assay_concs = unique(assay_data.concentration);
                for k = 1:size(assay_concs, 1)
                    assay_conc_data = assay_data(assay_data.concentration == assay_concs(k),:);
                    if size(assay_conc_data,1) > 1
                        row = assay_conc_data(1,:); row.response = mean(assay_conc_data.response);
                        row.reference = strjoin(assay_conc_data.reference, ',');
                        out_data = [out_data; row]; 
                    else
                        row = assay_conc_data(1,:);
                        out_data = [out_data; row];
                    end
                    
                end
            end
            out_assays = unique(out_data.assay);
            out_concs = unique(out_data.concentration);
            x = NaN(size(out_concs,1), size(out_assays,1)); y = NaN(size(out_concs,1), size(out_assays,1));
            z = strings(size(out_concs,1), size(out_assays,1));
            for m = 1:size(out_assays,1)
                for n = 1:size(out_concs,1)
                   resp = out_data(and(strcmp(out_data.assay, out_assays(m)),(out_data.concentration == out_concs(n))),:).response;
                   z(n,m) = out_assays(m);
                   if ~isempty(resp)
                       x(n,m) = out_concs(n);
                       y(n,m) = resp;
                   end
                end
            end
            if sum(sum(isnan(x),2) == 0) > 0
                ttl = strcat(unique(out_data.specie),'_',unique(out_data.odor)); xlbl = 'Assays'; ylbl = 'Preference Index';
                plot_paired_comparison(x, y, z, ttl, xlbl, ylbl, color, output_folder);
            end
        end
    end
    
end

end

