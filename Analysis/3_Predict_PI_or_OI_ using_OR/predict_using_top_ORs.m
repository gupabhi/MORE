function pred = predict_using_top_ORs(train_data, pred_data, top_ORs)

%% Predict

train_regmat = train_data(:, [top_ORs; 'response']);
pred_regmat = pred_data(:, [top_ORs; 'response']);

mdl = fitglm(train_regmat,'ResponseVar','response');
pred = predict(mdl, pred_regmat);


end

