function [shuff_act_data, shuff_data] = shuffle_matrices(data, num_trial)

rng(0)  % intialize random number generator

shuffle_matrix1 = zeros(size(data, 1), size(data, 2), num_trial);
shuffle_matrix2 = zeros(size(data, 1), size(data, 2), num_trial);

for i =1:num_trial
    idx = randperm(length(data(:)));
    sdata = data(idx); sdata = reshape(sdata, size(data, 1), size(data, 2));
    shuffle_matrix1(:, :, i) = abs(sdata - data);
    shuffle_matrix2(:, :, i) = sdata;
    
end
shuff_act_data = mean(shuffle_matrix1, 3);
shuff_data =  shuffle_matrix2;

end

