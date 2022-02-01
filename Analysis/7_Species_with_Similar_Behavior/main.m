% Goal: Find out species of mosquito who shows similar behavior
clear; clc; format longg; close;

%% Initializing variables
color.r = [0.96 0.37 0.59]; color.g = [0.3 1 0.3]; color.b = [0.4 0.6 1];
output_folder = './output/';

%% load structured data
input_file = './input/2020_04_08_structured_dataset.xlsx';
% mos_behvr = read_excelsheet(input_file, 'Mos_Behaviour', 'mos_behvr', './input/');

load('./input/mos_behvr.mat');

%% Data pre-processing
% data = data_preprocessing(mos_behvr(:, {'odor', 'concentration', 'concentration_type', ...
%                 'species', 'assay', 'reference', 'response'})); 
            
%% create datastructure separating different species data
min_species_data_required = 150;    % each species should have atleast these many datapoints -- filtering step
% [data_species, soi] = separate_species_data(data, min_species_data_required);  % soi -> species of interest

%% find out common datapoints
% data_species_pair = get_common_datapoints(data_species);
% save('./input/data_species_pair', 'data_species_pair');

load('./input/data_species_pair.mat');

%% plot correlation between a pair of species response
min_datapoints = 10;
plot_results(data_species_pair, min_datapoints, color, output_folder);

