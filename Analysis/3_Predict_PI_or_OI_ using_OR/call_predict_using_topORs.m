function call_predict_using_topORs(data, color, tag_name, output_folder)

% num_top = [1, 3, 5, 7, 9];
num_top = [5];

for n = 1:size(num_top,2)
    num_topORs = num_top(n);
    tag = strcat(tag_name,sprintf('_top%d',num_topORs));

    % create output correlation matrix for each OR
    ORs = data.Properties.VariableNames(1:end-3);
    varTypes = repmat({'double'}, 1, size(ORs,2)); varNames = ORs;
    corr_pi_or = table('Size',[size(data,1) size(ORs,2)],'VariableTypes',varTypes,'VariableNames',ORs);

    predicted = data;
    for o = 1:size(data,1)
        train_data = data; 
        train_data(o,:) = [];
        pred_data = data(o,:);

        corr_mat = get_top_ORs(train_data, color, tag, output_folder); % get top_ORs

        top_ORs = corr_mat.or(1:num_topORs);
        prd = predict_using_top_ORs(train_data, pred_data, top_ORs);

        % add boundary condition
        if prd < -1
            predicted.pred(o) = -1;
        elseif prd > 1
            predicted.pred(o) = 1;
        else
            predicted.pred(o) = prd;
        end
        
        % fill correlation matrix
        for i = 1:size(corr_mat, 1)
            idx = strcmp(corr_pi_or.Properties.VariableNames, corr_mat.or(i));
            corr_pi_or(o,idx) = array2table(corr_mat.r(i));
        end

    end

    %% plot 
    % comparison plot
%     plot_dist_based_results(predicted.pred, predicted.response, color, tag, output_folder)

    if num_topORs == 5
        % bar plot
        x = categorical(corr_pi_or.Properties.VariableNames)'; y = table2array(corr_pi_or)';
        ylbl = ['Absoulte Correlation between Preference' newline 'Index and OR Response']; xlbl = 'Odorant Receptor';
        plot_bar(repmat(x, 1, size(y,2)), y, color, '', xlbl, ylbl,strcat('bar_corr_pi_or_', tag), output_folder)
    end
end
    
end

