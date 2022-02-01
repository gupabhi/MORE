function predictions = get_control_predictions(predictions, num_shuffle)
% Give some actual and predicted responses, generate shuffle responses
% Note: Shuffle is the Control here.

rng(0); % initialize random number generator

% for distance between control and actual - average over all the num_shuffle trials
D_Ctrl_Act = [];

for i = 1:num_shuffle
    shuffName = strcat('Shuffle', string(i));   % shuffle trial name
    idx = randperm(size(predictions,1));        % get random indices
    shuffleData = predictions.Act(idx);
    
    % absolute difference - Distance between Pred/Ctrl and Act
    D_shuff_act = abs(shuffleData - predictions.Act);  
    D_Ctrl_Act = [D_Ctrl_Act D_shuff_act];
    
    predictions = addvars(predictions, shuffleData, 'NewVariableNames', shuffName);
    predictions = addvars(predictions, D_shuff_act, 'NewVariableNames', strcat('D_', shuffName, '_Act'));
end

% absolute difference - Distance between Pred and Act
D_Pred_Act = abs(predictions.Pred - predictions.Act);
D_Ctrl_Act = mean(D_Ctrl_Act, 2);

predictions = addvars(predictions, D_Pred_Act, 'NewVariableNames', 'D_Pred_Act');
predictions = addvars(predictions, D_Ctrl_Act, 'NewVariableNames', 'D_Ctrl_Act');

end

