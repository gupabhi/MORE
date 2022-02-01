function predictions = trainNetwork_for_each_OR(Odors_descriptors, ORs_responses, hidden_layers, output_folder)
% train network separately for each Odorant Receptor
predictions  = cell2table(cell(0,4), 'VariableNames', {'OR', 'Odor', 'Act', 'Pred'});
numORs = size(ORs_responses,1);  % number of ORs

for i = 1:numORs
    
    OR = char(ORs_responses{i,1});
    OR_Response = ORs_responses(i, 2:end);
    savename = strcat(OR, '_HiddenLayers_', strjoin(string(hidden_layers), '_'));
    
    %%%% Training %%%%
%     % define input and output for the network
%     input =  table2array(Odors_descriptors);
%     output = table2array(OR_Response);
    
%     %%% Initialize and Train the Network
%     net = feedforwardnet(hidden_layers);
%     [net,tr] = train(net, input, output);
    
%     %%% Save Network Output
%     trainedNetwork.net = net; trainedNetwork.tr = tr; 
%     save(strcat(output_folder, savename, '.mat'), 'trainedNetwork');
    
    % Load Network Output
    load(strcat(output_folder, savename, '.mat'), 'trainedNetwork');
    
    %%%% Predicting %%%%
    
    % Get Test Data for evaluation 
    idx_test = trainedNetwork.tr.testInd;
    
    % evaluation data contains both test
    idx_eval = sort(idx_test);    
    input_eval = Odors_descriptors(:, idx_eval);
    response_actual = OR_Response(:, idx_eval);
    
    % Predict Response given Descriptors
    response_predicted = trainedNetwork.net(table2array(input_eval));
    
    % store predicted and actual response values
    Odors = string(response_actual.Properties.VariableNames);
    
    for j = 1:size(Odors,2)
        odor = Odors(j);
        odor_idx = find(strcmp(response_actual.Properties.VariableNames, odor)); 
        
        predictions = [predictions; {OR, odor, table2array(response_actual(1,odor_idx)), response_predicted(1,odor_idx)}];
    end
    
    clearvars trainedNetwork;
end


end

