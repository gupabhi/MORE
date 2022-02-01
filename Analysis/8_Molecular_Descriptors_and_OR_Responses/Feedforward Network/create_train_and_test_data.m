function [trainDescriptors, trainResponse, testDescriptors, testResponse] = create_train_and_test_data(descriptors,responses)

num_odors = size(descriptors,2);

% Cross varidation (train: 70%, test: 30%)
cv = cvpartition(num_odors,'HoldOut',0.3);
idx = cv.test;

% Separate to training and test data
trainDescriptors = descriptors(:,~idx);
trainResponse = responses(:,~idx);

testDescriptors  = descriptors(:,idx);
testResponse = responses(:,idx);

end

