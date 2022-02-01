%% Goal: 1) merge current OR response data into spike data
close; clear; clc; format longg;

%% parameters
mkdir('./output');
output_folder = './output/';

% mkdir('./output/results_with_Afify2020');
% output_folder = './output/results_with_Afify2020/';

color.r = [0.96 0.37 0.59]; color.g = [0.3 1 0.3]; color.b = [0.4 0.6 1];

%% input data 
% data_loc = './input/2021_11_22_structured_dataset.xlsx';
data_loc = './input/2020_04_08_structured_dataset.xlsx';

dmel_behvr = read_excelsheet(data_loc, 'DMel_Behaviour');
mos_behvr = read_excelsheet(data_loc, 'Mos_Behaviour');
data.dmel_behvr = dmel_behvr; data.mos_behvr = mos_behvr;

% remove larval data
data.mos_behvr(contains(data.mos_behvr.assay, 'Larval'),:) = [];

save(strcat(output_folder,'data.mat'), 'data');
load(strcat(output_folder,'data.mat'));

data_dmel_behvr = data_preprocessing(data.dmel_behvr(:, {'odor', 'concentration', 'concentration_type', 'species', 'assay', 'reference', 'response'})); 
data_mos_behvr = data_preprocessing(data.mos_behvr(:, {'odor', 'concentration', 'concentration_type', 'species', 'assay', 'reference', 'response'}));

%% Odor response vs Odor Concentration
% mkdir(strcat(output_folder,'conc_resp/'))
% assays = unique(data_dmel_behvr.assay);
% for i = 1:size(assays,1)
%     savename = assays(i);
%     data_dmel_behvr_assay = data_dmel_behvr(strcmp(data_dmel_behvr.assay, assays(i)),:);
%     plot_odor_response_with_concentration(data_dmel_behvr_assay, color.r, savename, strcat(output_folder,'conc_resp/'));
% end
% 
% mos_species = unique(data_mos_behvr.species);
% for i = 1:size(mos_species,1)
%     data_behvr = data_mos_behvr(strcmp(data_mos_behvr.species, mos_species(i)),:);
%     assays = unique(data_behvr.assay);
%     for j = 1:size(assays,1)
%         savename = assays(j);
%         plot_odor_response_with_concentration(data_behvr, color.g,  savename, strcat(output_folder,'conc_resp/'));
%     end
% end

%% delta(Preference Index) Violin Plots
% mkdir(strcat(output_folder,'conc_resp/delta_PI/'))
% data_behvr = [data_dmel_behvr; data_mos_behvr];
% plot_delta_preference_index(data_behvr, color.b, strcat(output_folder,'conc_resp/delta_PI/'))

%% Variability across assays
% mkdir(strcat(output_folder,'assay_resp/'))
% plot_odor_response_with_assays(data_dmel_behvr, color.r, strcat(output_folder,'assay_resp/'))

% mos_species = unique(data_mos_behvr.specie);
% for i = 1:size(mos_species,1)
%     data_behvr = data_mos_behvr(strcmp(data_mos_behvr.specie, mos_species(i)),:);
%     plot_odor_response_with_assays(data_behvr, color.g, strcat(output_folder,'assay_resp/'))
% 
% end

%% ----Pairwise assay plot-----%
% plot_odor_response_with_pairwise_assays(data_dmel_behvr, color.r, strcat(output_folder,'assay_resp/'))
% 
% mos_species = unique(data_mos_behvr.specie);
% for i = 1:size(mos_species,1)
%     data_behvr = data_mos_behvr(strcmp(data_mos_behvr.specie, mos_species(i)),:);
%     plot_odor_response_with_pairwise_assays(data_behvr, color.g, strcat(output_folder,'assay_resp/'))
% end

%% Plot X assay Vs Non-X assay 
assay = 't-maze';
plot_assay_vs_non_assay(data_dmel_behvr, assay, color.r, strcat(output_folder,'assay_resp/'))

x = array2table(zeros(0,2)); y = array2table(zeros(0,2)); 
z = array2table(zeros(0,2)); o = array2table(zeros(0,2));

assay = 'landing';
mos_species = unique(data_mos_behvr.species);
for i = 1:size(mos_species,1)
    if sum(strcmp(mos_species(i), 'aaeg')) || sum(strcmp(mos_species(i), 'cqui')) 
        data_behvr = data_mos_behvr(strcmp(data_mos_behvr.species, mos_species(i)),:);
        out = plot_assay_vs_non_assay(data_behvr, assay, color.g, strcat(output_folder,'assay_resp/'));
        
        x = [x; out.x]; y = [y; out.y]; z = [z; out.z]; o = [o; out.o];
    end
end

x = table2array(x); y = table2array(y); z = table2array(z); o = table2array(o); 

ttl = 'aaeg_cqui'; 
savename = strcat('aaeg_cqui_', assay, '_vs_non-', assay);
xlbl = ''; ylbl = 'Preference Index'; o = repmat(1:size(o,1), 2,1)';

if strcmp(assay, 'landing')
    z = repmat({'Landing', 'Non-Landing'}, size(z,1), 1);
end

plot_pairwise_assay_paired_comparison(x, y, z, o, ttl, xlbl, ylbl, color.g, savename, strcat(output_folder,'assay_resp/'));



% 
% % for positive and negative Preference index plot separately
% yp = y(y(:,2)>0, :); xp = x(y(:,2)>0, :); zp = z(y(:,2)>0, :); op = o(y(:,2)>0, :);
% plot_pairwise_assay_paired_comparison(xp, yp, zp, op, strcat(ttl, '_positivePI_non-landing'), xlbl, ylbl, color.g, ...
%             strcat(savename,'_positivePI_non-landing'), strcat(output_folder,'assay_resp/'));
% 
% yn = y(y(:,2)<=0, :); xn = x(y(:,2)<=0, :); zn = z(y(:,2)<=0, :); on = o(y(:,2)<=0, :);
% plot_pairwise_assay_paired_comparison(xn, yn, zn, on, strcat(ttl, '_negativePI_non-landing'), xlbl, ylbl, color.g, ...
%             strcat(savename,'_negativePI_non-landing'), strcat(output_folder,'assay_resp/'));
%         
% % for positive and negative Preference index plot separately
% yp = y(y(:,1)>0, :); xp = x(y(:,1)>0, :); zp = z(y(:,1)>0, :); op = o(y(:,1)>0, :);
% plot_pairwise_assay_paired_comparison(xp, yp, zp, op, strcat(ttl, '_positivePI_landing'), xlbl, ylbl, color.g, ...
%             strcat(savename,'_positivePI_landing'), strcat(output_folder,'assay_resp/'));
% 
% yn = y(y(:,1)<=0, :); xn = x(y(:,1)<=0, :); zn = z(y(:,1)<=0, :); on = o(y(:,1)<=0, :);
% plot_pairwise_assay_paired_comparison(xn, yn, zn, on, strcat(ttl, '_negativePI_landing'), xlbl, ylbl, color.g, ...
%             strcat(savename,'_negativePI_landing'), strcat(output_folder,'assay_resp/'));
        

