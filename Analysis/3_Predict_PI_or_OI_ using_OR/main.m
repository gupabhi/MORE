% Goal: 1) build a regression model between preference index (PI) and OR
% response for drosophila and mosquitoes
% 2) check whether the ORs with similar weights in DMel or Mosquito are orthologous or not
clear; clc; format longg; close;

%% Initializing variables
color.r = [0.96 0.37 0.59]; color.g = [0.3 1 0.3]; color.b = [0.4 0.6 1];
output_folder = './output/';

%% load sequence data
load('./input/dseq.mat'); load('./input/aseq.mat'); % read dmel and agam sequences
load('./input/dmel_7TM.mat'); load('./input/agam_7TM.mat'); % load 7TM data 

%% load structured data
input_file = './input/2020_04_08_structured_dataset.xlsx';

% dmel_behvr = read_excelsheet(input_file, 'DMel_Behaviour','dmel_behvr', './input/');
% mos_behvr = read_excelsheet(input_file, 'Mos_Behaviour', 'mos_behvr', './input/');
% dmel_or = read_excelsheet(input_file, 'DMel_OR', 'dmel_or', './input/');
% mos_or = read_excelsheet(input_file, 'Mos_OR', 'mos_or', './input/');
% dmel_behvr = read_excelsheet(input_file, 'DMel_Oviposition','dmel_ovi', './input/');
% mos_behvr = read_excelsheet(input_file, 'Mos_Oviposition', 'mos_ovi', './input/');

load('./input/mos_behvr.mat'); load('./input/mos_or.mat'); load('./input/mos_ovi.mat');
load('./input/dmel_behvr.mat'); load('./input/dmel_or.mat'); load('./input/dmel_ovi.mat');

data.dmel_behvr = dmel_behvr; data.mos_behvr = mos_behvr; 
data.dmel_or = dmel_or; data.mos_or = mos_or; 
data.dmel_ovi = dmel_ovi; data.mos_ovi = mos_ovi; 

%% create dataset for regression analysis 
% % for Preference index
% dregmat = create_regression_matrix(data.dmel_behvr, data.dmel_or);
% mregmat = create_regression_matrix(data.mos_behvr, data.mos_or);
% 
% save(sprintf('%sdregmat.mat', output_folder), 'dregmat'); 
% save(sprintf('%smregmat.mat', output_folder), 'mregmat');

load(sprintf('%sdregmat.mat', output_folder)); 
load(sprintf('%smregmat.mat', output_folder));

%% Select the criteria to treat NaNs
% for Preference index
save_tag_name = 'rmv_ORs_with_morethan_half_NaNs';
output_folder = strcat(output_folder, save_tag_name, '/'); mkdir(output_folder);
fields = fieldnames(mregmat.agam);
% fields = fieldnames(dregmat.dmel);

m_num_NaN = [size(mregmat.agam.(fields{1}),1)/2, size(mregmat.agam.(fields{2}),1)/2, size(mregmat.agam.(fields{3}),1)/2];
d_num_NaN = [size(dregmat.dmel.(fields{1}),1)/2, size(dregmat.dmel.(fields{2}),1)/2, size(dregmat.dmel.(fields{3}),1)/2];  

%% NaNs treatment
% % for preference index
% mregmat = replace_NaN_with_row_mean(mregmat,m_num_NaN); 
% dregmat = replace_NaN_with_row_mean(dregmat, d_num_NaN); 
% 
% save(sprintf('%smregmat_%s.mat', output_folder, save_tag_name), 'mregmat'); 
% save(sprintf('%sdregmat_%s.mat', output_folder, save_tag_name), 'dregmat');

load(sprintf('%smregmat_%s.mat', output_folder, save_tag_name)); 
load(sprintf('%sdregmat_%s.mat', output_folder, save_tag_name));

%% Merge datapoints with same OR responses
% % for preference index
% mregmat_merged =  merge_datapoints_with_same_OR_resp(mregmat, data.mos_or);
% dregmat_merged =  merge_datapoints_with_same_OR_resp(dregmat, data.dmel_or);

% save(sprintf('%smregmat_merged_%s.mat', output_folder, save_tag_name), 'mregmat_merged');
% save(sprintf('%sdregmat_merged_%s.mat', output_folder, save_tag_name), 'dregmat_merged');

load(sprintf('%smregmat_merged_%s.mat', output_folder, save_tag_name)); 
load(sprintf('%sdregmat_merged_%s.mat', output_folder, save_tag_name));

%% predict
% call_predict_using_topORs(mregmat_merged.agam.conc_range, color.g, 'agam', output_folder);
% call_predict_using_topORs(dregmat_merged.dmel.conc_range, color.r, 'dmel', output_folder);

%% Correlation between preference index and oviposition index
mkdir('./output/corr_pi_oi/');

corr_pi_oi(data.dmel_behvr,data.dmel_ovi, color.r, './output/corr_pi_oi/')
corr_pi_oi(data.mos_behvr,data.mos_ovi, color.g, './output/corr_pi_oi/')

%% Correlation between larvae and adult behaviour 
% plot_corr_adult_larvae_behvr(data, color.g, output_folder)



