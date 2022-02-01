% input: data_behvr: behavioural data; data_OR: OR response data; 
% output: matrix containing OR responses, response (PI), concentration,for odors 
%     (for all the three criteria - same_conc, conc_range, closest_conc)

function reg_mat = create_regression_matrix(data_behvr, data_OR)
format longg;

%% data preprocessing
data_behvr = data_preprocessing(data_behvr(:, {'odor', 'concentration', 'concentration_type', ...
                'species', 'assay', 'reference', 'response'})); 

data_OR = data_preprocessing(data_OR(:, {'odor', 'concentration', 'concentration_type', ...
                'species', 'or', 'reference', 'response'}));

%% find common rows between two datasets
exact_match_cols = {'odor', 'concentration_type', 'species'};
common_species = intersect(unique(data_behvr.species),unique(data_OR.species));

for i = 1:size(common_species,1)
    
    % get data for a common species in both the datasets
    data_behvr_species = data_behvr(strcmp(data_behvr.species, common_species(i)),:);   
    data_OR_species = data_OR(strcmp(data_OR.species, common_species(i)),:);

    % find common rows in the behvr and OR datasets
    common_rows = intersect(data_behvr_species(:,exact_match_cols), data_OR_species(:,exact_match_cols));
    data_behvr_species = data_behvr_species(ismember(data_behvr_species(:,exact_match_cols),common_rows,'rows'), :);
    data_OR_species = data_OR_species(ismember(data_OR_species(:,exact_match_cols),common_rows,'rows'),:);
    
    % merge duplicate rows in the dataset; replacing response with means
    data_behvr_species = merge_rows_and_replace_resp_with_mean(data_behvr_species, ...
            {'odor', 'concentration_type', 'concentration', 'species'},'response', 'reference', 'assay');
    data_OR_species = merge_rows_and_replace_resp_with_mean(data_OR_species, ...
            {'odor', 'concentration_type', 'concentration', 'species', 'or'},'response', 'reference');
    
    % get regression matrix with preference index and OR responses
    reg_mat.(common_species{i}) = create_PI_OR_resp_matrix(data_behvr_species,data_OR_species);

end

end


