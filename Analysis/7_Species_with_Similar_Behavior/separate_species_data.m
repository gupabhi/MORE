function [out, soi] = separate_species_data(data, min_species_data_required)
%separate_species_data - given all the data separate data belongs to different species 

out = struct;
soi = [];   % species of interest

species = unique(data.species);
for s = 1:size(species, 1)
   sp =  species(s);

   species_data = data((data.species == sp), :);
   % If number of data points is greater than 150 then we are going to use it
   if size(species_data, 1) > min_species_data_required
       soi = [soi; sp];
       out.(sp) = species_data;
   end
end

end

