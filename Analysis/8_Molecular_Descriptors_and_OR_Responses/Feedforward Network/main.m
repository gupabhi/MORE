clear; clc; format longg; close all;
%%% Description %%%
% Input - Odor Descriptors and OR-odor response data
% Output - Create a feedforward deep learning model which takes odor
% descriptors as an input and predict the odor-OR responses. 

%% Initialize Variables
output_folder = './output/';
if ~exist(output_folder, 'dir'), mkdir(output_folder);end
color.r = [0.96 0.37 0.59]; color.g = [0.3 1 0.3]; color.b = [0.4 0.6 1];

%% Load OR Response Data 
input_OR_respdata = './input/2021_12_05_structured_dataset.xlsx';
% data_OR_respdata = readtable(input_OR_respdata, 'Sheet', 'Mos_OR');

% save('./input/data_OR_respdata.mat', 'data_OR_respdata');
load('./input/data_OR_respdata.mat');

%% Create OR-Odor response matrix
% Odor_OR_Responses = create_OR_odor_response_matrix(data_OR_respdata);
% save(strcat(output_folder, 'Odor_OR_Responses.mat'), 'Odor_OR_Responses');
load(strcat(output_folder, 'Odor_OR_Responses.mat'));

% writetable(Odor_OR_Responses,strcat(output_folder, 'Odor_OR_Response.xlsx'));
% save(strcat(output_folder, 'Odor_OR_Responses.mat'), 'Odor_OR_Responses');
load(strcat(output_folder, 'Odor_OR_Responses.mat'));

% OR_responses = Odor_OR_Responses(:, 2:end);
% save(strcat(output_folder, 'OR_responses.mat'), 'OR_responses');
load(strcat(output_folder, 'OR_responses.mat'));

%% Get Descriptor Data
% filepath = './input/odor-selected-descriptors-data.csv';
% Odors_descriptors = create_descriptor_odor_matrix(filepath, OR_responses, output_folder);
% 
% save(strcat(output_folder, 'Odors_descriptors.mat'), 'Odors_descriptors');
load(strcat(output_folder, 'Odors_descriptors.mat'));

%% Neural Network Parameters
hidden_layers = [50 50 50]; % number of neurons in each hidden layer
num_shuffle = 1;   % number of times shuffling should be performed

%% Create several feed forward neural network for each OR
% predictions = trainNetwork_for_each_OR(Odors_descriptors, Odor_OR_Responses, hidden_layers, output_folder);

% save(strcat(output_folder, 'predictions.mat'), 'predictions');
load(strcat(output_folder, 'predictions.mat'), 'predictions');

%% Get Control Predictions
% predictions_with_control = get_control_predictions(predictions, num_shuffle);

% save(strcat(output_folder, 'predictions_with_control.mat'), 'predictions_with_control');
load(strcat(output_folder, 'predictions_with_control.mat'), 'predictions_with_control');

%% Plot and compare predictions with control
% % plot correaltion violin graph between: -
% % (1) Corr(Pred, Act), (2) Corr(Ctrl, Act)
% plot_correlation(predictions_with_control, num_shuffle, color, output_folder);

% plot difference between predicted_error and ctrl_error (Dpred,act - Dctrl,act)
plot_error(predictions_with_control, num_shuffle, color, output_folder);



