function plot_corr_adult_larvae_behvr(data, color, output_folder)

out = cell2table(cell(0,2));

data.mos_behvr.odor = lower(data.mos_behvr.odor);
Ldata = data.mos_behvr(strcmp(data.mos_behvr.assay, 'Larval'), :);
Adata = data.mos_behvr(~strcmp(data.mos_behvr.assay, 'Larval'), :);


for i = 1:size(Ldata,1)
    odor = Ldata.odor(i);
    conc = Ldata.concentration(i);
    species = Ldata.species(i);
    
    species_data =  Adata(Adata.species == species, :);
    odor_data = species_data(species_data.odor == odor, :);
    if size(odor_data, 1) > 0
       conc_data = odor_data(odor_data.concentration == conc, :); 
       out = [out; cell2table({mean(conc_data.response), Ldata.response(i)})];
    end
    
    
end
out.Properties.VariableNames = {'adult', 'larvae'};
x = table2array(out(:,1)); y = table2array(out(:,2)); 
ttl = 'Preference Index - Adult Vs Larvae'; 
xlbl = 'Preference Index in Adult'; ylbl = 'Preference Index in Larvae';
savename = 'scatter_preference_index_adult_vs_larvae';
plot_scatter(x, y, color, ttl, xlbl, ylbl, savename, output_folder, 1)

end

