% Goal: Determine the Odor-Concentration pair for which behavior is
% attractive and also figure out the ORs that are active in such Odor-conc
% pair
clear; clc; format longg; close;

%% Initializing variables
input_file = './input/2020_04_08_structured_dataset_without_larvaldata.xlsx';

% create output folder
output_folder = './output/without larval data/';
if ~exist(output_folder, 'dir')
       mkdir(output_folder);
end

color.r = [0.96 0.37 0.59]; color.g = [0.3 1 0.3]; color.b = [0.4 0.6 1];

%% load structured data
% dmel_behvr = read_excelsheet(input_file, 'DMel_Behaviour','dmel_behvr', './input/');
% mos_behvr = read_excelsheet(input_file, 'Mos_Behaviour', 'mos_behvr', './input/');
% dmel_or = read_excelsheet(input_file, 'DMel_OR', 'dmel_or', './input/');
% mos_or = read_excelsheet(input_file, 'Mos_OR', 'mos_or', './input/');

load('./input/mos_behvr.mat'); load('./input/mos_or.mat'); 
load('./input/dmel_behvr.mat'); load('./input/dmel_or.mat'); 

data.dmel_behvr = dmel_behvr; data.mos_behvr = mos_behvr; 
data.dmel_or = dmel_or; data.mos_or = mos_or; 

%% create dataset for regression analysis 
% % for Preference index
% dregmat = create_regression_matrix(data.dmel_behvr, data.dmel_or);
% mregmat = create_regression_matrix(data.mos_behvr, data.mos_or);
% 
% save(sprintf('%sdregmat.mat', output_folder), 'dregmat'); 
% save(sprintf('%smregmat.mat', output_folder), 'mregmat');

load(sprintf('%sdregmat.mat', output_folder)); 
load(sprintf('%smregmat.mat', output_folder));

%% Merge datapoints with same OR responses
% for preference index
% mregmat_merged =  merge_datapoints_with_same_OR_resp(mregmat, data.mos_or);
% dregmat_merged =  merge_datapoints_with_same_OR_resp(dregmat, data.dmel_or);
% 
% save(sprintf('%smregmat_merged_%s.mat', output_folder), 'mregmat_merged');
% save(sprintf('%sdregmat_merged_%s.mat', output_folder), 'dregmat_merged');

load(sprintf('%smregmat_merged_%s.mat', output_folder)); 
load(sprintf('%sdregmat_merged_%s.mat', output_folder));

%% Compute fractions of neurons activated
activation_threshold = 10; % units - spike rate | <=thresh -> neuron inactive
label_threshold_PI = 0.6;
label_threshold_fNeuron = 0.1;

mregmat_with_fNeurons = compute_fraction_neurons_activated(mregmat_merged, ...
    activation_threshold, label_threshold_PI, label_threshold_fNeuron, color.g, output_folder);

dregmat_with_fNeurons = compute_fraction_neurons_activated(dregmat_merged, ...
    activation_threshold, label_threshold_PI, label_threshold_fNeuron, color.r, output_folder);



