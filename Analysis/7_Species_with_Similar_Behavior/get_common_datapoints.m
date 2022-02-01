function out = get_common_datapoints(data_species)
%get_common_datapoints find out the common data points between a pair of
%species and plot the correlation

species =  fieldnames(data_species);
species_pairs = nchoosek(species,2);

for i = 1:size(species_pairs, 1)
    pair_name = strcat(species_pairs{i,1}, '_', species_pairs{i,2});
    
    data_behvr1 = data_species.(species_pairs{i,1});
    data_behvr2 = data_species.(species_pairs{i,2});
    
    out.(pair_name) = create_response_matrix(data_behvr1,data_behvr2);
end


end

