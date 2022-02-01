% Main file to run all the analysis functions
clear; clc; close;

%% defining variables
color.r = [0.96 0.37 0.59]; color.g = [0.2 0.8 0.2]; color.b = [0.3 0.8 1];
output_folder = './output/';
properties = {'MolecularWeight', 'XLogP', 'Complexity', 'TPSA', 'HBondDonorCount', 'HBondAcceptorCount', ...
    'RotatableBondCount', 'HeavyAtomCount', 'Charge', 'IsotopeAtomCount', 'AtomStereoCount', ...
    'DefinedAtomStereoCount', 'UndefinedAtomStereoCount', 'CovalentUnitCount', 'Volume3D', ...
    'XStericQuadrupole3D', 'YStericQuadrupole3D', 'ZStericQuadrupole3D', 'FeatureCount3D', ...
    'FeatureAcceptorCount3D', 'FeatureDonorCount3D', 'FeatureAnionCount3D', 'FeatureCationCount3D', ...
    'FeatureRingCount3D', 'FeatureHydrophobeCount3D', 'ConformerModelRMSD3D', 'EffectiveRotorCount3D',...
    'ConformerCount3D', 'Fingerprint2D', 'CanonicalSMILES', 'InChIKey'};

prop_to_plot = {'MolecularWeight', 'Volume3D', 'XLogP', 'Complexity', 'ConformerCount3D', ...
    'EffectiveRotorCount3D', 'FeatureCount3D', 'HeavyAtomCount', 'RotatableBondCount', 'TPSA', ...
    'XStericQuadrupole3D', 'YStericQuadrupole3D', 'ZStericQuadrupole3D'};

%% Loading input data
data_loc = './input/2020_04_08_structured_dataset.xlsx';
% data_mos_or = read_excelsheet(data_loc, 'Mos_OR', 'data_mos_or', './input/');
% data_dmel_or = read_excelsheet(data_loc, 'DMel_OR', 'data_dmel_or', './input/');

load('./input/data_mos_or.mat'); load('./input/data_dmel_or.mat'); 

%% Data Preprocessing
% data_mos_or = data_preprocessing(data_mos_or(:, {'odor', 'concentration', 'concentration_type',...
%              'species', 'gender', 'or', 'reference', 'response'})); 
% data_dmel_or = data_preprocessing(data_dmel_or(:, {'odor', 'concentration', 'concentration_type',...
%              'species', 'gender', 'or', 'reference', 'response'}));

%% get odor properties
% data_mos_or = get_odor_properties(data_mos_or, properties, 'data_mos_or', output_folder);
% data_dmel_or = get_odor_properties(data_dmel_or, properties, 'data_dmel_or', output_folder);

load(sprintf('%s%s_w_prop.mat', output_folder, 'data_mos_or'));
load(sprintf('%s%s_w_prop.mat', output_folder, 'data_dmel_or'));

data_mos = data_mos_or_w_prop(data_mos_or_w_prop.concentration == 0.01,:); 
data_dmel = data_dmel_or_w_prop(data_dmel_or_w_prop.concentration == 0.01,:);

%% calcualte xlim for each property
% axisLimit = calculate_axis_limits(data_mos, data_dmel, prop_to_plot);

%% anaylsis to compare Or response with odor properties
% resp_prop(data_mos, prop_to_plot, color.g, axisLimit, 'mos_10e2', output_folder);
% resp_prop(data_dmel, prop_to_plot, color.r, axisLimit, 'dmel_10e2', output_folder);

%% Check correlation between pair of properties
data = [data_mos; data_dmel]; data = data(:, ['odor', prop_to_plot]);
[~, ia, ~] = unique(data(:, 'odor'));

plot_scatter_btw_propty_pair(data(ia,:), color.b, strcat(output_folder, 'corr_pair_prop/'))

%% compare response with similarity coefficients
% resp_sim(data, scatter_dot_size, a_color, d_color, resp_col_range, output_folder)


