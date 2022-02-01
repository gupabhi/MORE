%% Method:-
% For each concentration for which a higher concentration is also available, calculate the change 
% is preference index in going from that concentration to the higher concentration. 
% this is only done for those concentration for which at least two data points are present
% for each lower concentration, you get one delta-PI value. Let's say you have 40 such delta-PI 
% values. Divide these delta-PI values into two groups based on whether the PI for the lower 
% concentration was positive or negative. Show the violins for the two groups of delta-PI values 
% within the same plot, and also do a non-pairwise  statistical comparison between the two groups. 
% Also make another plot with just one violin with all the delta-PI values.
  
function plot_delta_preference_index(data_behvr, color, output_folder)

%% plot violin of preference index Vs odor concentration

out_data = array2table(zeros(0,size(data_behvr.Properties.VariableNames,2)));
out_data.Properties.VariableNames = data_behvr.Properties.VariableNames;
mat_all_conc = array2table(zeros(0,2)); mat_all_resp = array2table(zeros(0,2)); mat_all_odor = array2table(zeros(0,2));
mat_all_species = array2table(zeros(0,1)); mat_all_assay = array2table(zeros(0,1)); 
        
data_behvr.concentration = round(log10(data_behvr.concentration));

species = unique(data_behvr.species);
for s = 1:size(species,1)
    data_behvr_species = data_behvr(strcmp(data_behvr.species, species(s)),:);
    
    assays = unique(data_behvr_species.assay);
    for a = 1:size(assays,1)
        mat_conc = array2table(zeros(0,2)); mat_resp = array2table(zeros(0,2)); mat_odor = array2table(zeros(0,2));
        mat_species = array2table(zeros(0,1)); mat_assay = array2table(zeros(0,1)); 
        
        data_behvr_species_assay = data_behvr_species(strcmp(data_behvr_species.assay, assays(a)),:);
        
        odors = unique(data_behvr_species_assay.odor);
        for i = 1:size(odors,1)
            odor_data = data_behvr_species_assay(strcmp(data_behvr_species_assay.odor, odors(i)),:);
            concs = unique(odor_data.concentration);

            % plot for more than 1 concentration
            if (size(concs, 1) > 1)             
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

                    % get matrix with lower and higher concentration pair values
                    all_conc = sort(unique(x));
                    for k =1:size(all_conc,1)-1
                       mat_odor = [mat_odor; {odors(i), odors(i)}]; 
                       mat_all_odor = [mat_all_odor; {odors(i), odors(i)}];
                       
                       mat_conc = [mat_conc; {all_conc(k), all_conc(k+1)}]; 
                       mat_all_conc = [mat_all_conc; {all_conc(k), all_conc(k+1)}];
                       
                       mat_resp = [mat_resp; {mean(y(x == all_conc(k))), mean(y(x == all_conc(k+1)))}];
                       mat_all_resp = [mat_all_resp; {mean(y(x == all_conc(k))), mean(y(x == all_conc(k+1)))}];
                       
                       mat_species = [mat_species; {species(s)}];
                       mat_all_species = [mat_all_species; {species(s)}];
                       
                       mat_assay = [mat_assay; {assays(a)}];
                       mat_all_assay = [mat_all_assay; {assays(a)}];
                    end

                end
            end
        end
        
        if size(mat_resp,1) > 1
            deltaPI = mat_resp{:,2} - mat_resp{:,1};

            % all_deltaPI violin plot
            x = repmat({'all'}, size(deltaPI, 1),1); y = deltaPI;
            [~, p_val_t] = ttest(y, 0);
            p_val_s = signrank(y, zeros(size(y)), 'Method','exact');
            
            sp = strjoin(unique(table2array(mat_species)), '_');
            ttl = strcat('',assays{a}, '_', sp); xlbl = strcat('[p_t = ', sprintf('%0.2e',p_val_t),...
                            ', p_s = ', sprintf('%0.2e',p_val_s),', n = ', num2str(size(y,1)),', m = ', num2str(round(mean(y),2)), ']'); 
            ylbl = 'Change in Preference Index (High -Low)'; bandwidth = 0.05;
            
            if strcmp(assays{a}, 'landing') && strcmp(sp, 'aaeg')
                bandwidth = 0.05;
            elseif strcmp(assays{a}, 'dual-port') && strcmp(sp, 'aalb')
                bandwidth = 0.2;
            elseif strcmp(assays{a}, 't-maze') && strcmp(sp, 'dmel')
                bandwidth = 0.1;
            elseif strcmp(assays{a}, 'y-maze') && strcmp(sp, 'dmel')
                bandwidth = 0.2;
            end
            
%             plot_violin(x, y, {ttl}, xlbl, ylbl, color, bandwidth, output_folder);
            clear p_val_s p_val_t
        end
    end
end

%% plot deltaPI value for all combination
deltaPI_all = mat_all_resp{:,2} - mat_all_resp{:,1};

% group deltaPI violin plot
x = repmat({'all'}, size(deltaPI_all, 1),1); y = deltaPI_all;
[~, p_val_t] = ttest(y, 0);
p_val_s = signrank(y, zeros(size(y)), 'Method','exact');

ttl = strcat('all_deltaPI'); xlbl = strcat('[p = ', sprintf('%0.2e',p_val_t),...
                ', p_s = ', sprintf('%0.2e',p_val_s),', n = ', num2str(size(y,1)),', m = ', num2str(round(mean(y),2)), ']'); 
ylbl = 'Change in Preference Index (High - Low)'; bandwidth = 0.4;

plot_violin(x, y, {ttl}, xlbl, ylbl, color, bandwidth, output_folder)


%%  for positive and negative PI of lower concentration
% for positive
respP = mat_all_resp(mat_all_resp{:,1} > 0, :);
deltaPI_P = respP{:,2} - respP{:,1};

% group deltaPI violin plot
x = repmat({'positivePI'}, size(deltaPI_P, 1),1); y = deltaPI_P;
[~, p_val_t] = ttest(y, 0);
p_val_s = signrank(y, zeros(size(y)), 'Method','exact');

ttl = strcat('deltaPI_positivePI_LowerConc'); xlbl = strcat('[p = ', sprintf('%0.2e',p_val_t),...
                ', p_s = ', sprintf('%0.2e',p_val_s),', n = ', num2str(size(y,1)),', m = ', num2str(round(mean(y),2)), ']'); 
ylbl = 'Change in Preference Index (High - Low)'; bandwidth = 0.4;

plot_violin(x, y, {ttl}, xlbl, ylbl, color, bandwidth, output_folder);

% for negative
respN = mat_all_resp(mat_all_resp{:,1} < 0, :);
deltaPI_N = respN{:,2} - respN{:,1};

% group deltaPI violin plot
x = repmat({'negativePI'}, size(deltaPI_N, 1),1); y = deltaPI_N;
[~, p_val_t] = ttest(y, 0);
p_val_s = signrank(y, zeros(size(y)), 'Method','exact');

ttl = strcat('deltaPI_negativePI_LowerConc'); xlbl = strcat('[p = ', sprintf('%0.2e',p_val_t),...
                ', p_s = ', sprintf('%0.2e',p_val_s),', n = ', num2str(size(y,1)),', m = ', num2str(round(mean(y),2)), ']'); 
ylbl = 'Change in Preference Index (High - Low)'; bandwidth = 0.2;

plot_violin(x, y, {ttl}, xlbl, ylbl, color, bandwidth, output_folder)

end

