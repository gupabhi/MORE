function out = compute_fraction_neurons_activated(data, activation_threshold, label_threshold_PI, label_threshold_fNeuron, color, output_folder)
%compute_fraction_neurons_activated Summary of this function goes here
%   Given OR-Conc-PI-Odor pair find out fraction of ORs activated
%   threshold - spike rate threshold above which neuron is assumed to be active

data_fields = fieldnames(data);
for i = 1:size(data_fields)
   subdata_fields = fieldnames(data.(data_fields{i}));
   
   for j = 1:size(subdata_fields)
       mat = data.(data_fields{i}).(subdata_fields{j}); 
       mat.fraction = nan(size(mat, 1), 1);
       
       for k = 1:size(mat,1)
           
          % "end-5" to avoid last rows which are not OR responses
          row = table2array(mat(k,1:end-5)); 
          or_activated_idx = (row >= activation_threshold);
          mat.fraction(k) = sum(or_activated_idx)/size(row,2); 
          ors_activated = mat.Properties.VariableNames(or_activated_idx);
          
         
%           % NOT A GOOD WAY BUT WROTE IN A HURRY
%           % For DMel - to check which ORs are activated for labeled odors
%           if  (k == 130) || (k==216)
%                disp([table2array(mat(k,53)), sum(or_activated_idx)]);
%                disp(ors_activated);
%           end
          
       end
       
       data.(data_fields{i}).(subdata_fields{j}) = mat;
       
       % Plot fraction of ORs activated Vs Preference Index/ Response
       x = data.(data_fields{i}).(subdata_fields{j}).response;
       y = data.(data_fields{i}).(subdata_fields{j}).fraction;
       
       str_odor = capatalize_first_letter(data.(data_fields{i}).(subdata_fields{j}).odor);
       str_conc = strcat(string(data.(data_fields{i}).(subdata_fields{j}).concentration*100), '%');
       str_assay = data.(data_fields{i}).(subdata_fields{j}).assay;
       
       txt = strcat(str_odor, ',', ' ', str_conc, ',', ' ', str_assay);
%        txt = cellfun(@(a, b, c) sprintf('(%s, %s, %s)', a, b, c), ...
%            data.(data_fields{i}).(subdata_fields{j}).odor, ...
%            num2cell(data.(data_fields{i}).(subdata_fields{j}).concentration), ...
%            data.(data_fields{i}).(subdata_fields{j}).assay, 'UniformOutput', false);
       
       for t = 1:size(txt, 1)
          if ~((x(t)>= label_threshold_PI) && (y(t) <= label_threshold_fNeuron))
              txt(t) = {''};
          end
       end
       
       xlbl = 'Preference Index';
       ylbl = 'Fraction of ORs Activated';
       ttl = data_fields{i};
       savename = sprintf('plot_fNeuron_PI_%s_%s', data_fields{i}, subdata_fields{j});
       
       plot_scatter(x, y, color, ttl, xlbl, ylbl, savename, output_folder, 0, txt)

   end
   
end
out = data;


end

