%% Goal: 1) merge current OR response data into spike data
clear; clc; format longg;

%% input data 
data_loc = './input/2020_04_08_structured_dataset.xlsx';
% data_mos_or = read_excelsheet(data_loc, 'Mos_OR');
% data_mos_or_curr = read_excelsheet(data_loc, 'Mos_OR_Current');

load('./input/data_mos_or.mat');
load('./input/data_mos_or_curr.mat');

%% parameters
mkdir('./output');
output_folder = './output/';
color.r = [0.96 0.37 0.59]; color.g = [0.3 1 0.3]; color.b = [0.4 0.6 1];

%% data initialization & preprocessing
data_mos_or = data_preprocessing(data_mos_or(:, {'odor', 'species', 'or', 'reference', 'response'})); 
data_mos_or_curr = data_preprocessing(data_mos_or_curr(:, {'odor','species', 'or','reference', 'response'}));

threshold_nA = 900; % above this threshold label all the points
plot_resp_to_common_odors(data_mos_or, data_mos_or_curr, threshold_nA, color, output_folder)
