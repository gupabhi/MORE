%% Need to cross check -- might be some error

% Given: CID of all odors from structured dataset
% Ouput: CID for odors in Hallem and Carey Study 
function get_cid(Odor_cid, data_carey, data_hallem)

all_odors = table2array(Odor_cid(:, 'Odor'));
all_cids = table2array(Odor_cid(:, 'cid'));

%% Carey2010
data = data_carey;
carey_odors = lower(table2array(data(:, 'Odor'))); 
carey_cids = int16.empty(size(carey_odors, 1),0);

for i = 1:size(carey_odors, 1)
    if sum(strcmp(all_odors, carey_odors(i,1)))     % if carey is present in all_odors
        index = find(strcmp(all_odors, carey_odors(i,1)));
        carey_cids(i, 1) = all_cids(index,1);
        disp(index);
    else
        disp('Odor not found in all_odors');
    end
   
end

%% Hallem2006
data = data_hallem;
hallem_odors = lower(table2array(data(:, 'Odor'))); 
hallem_cids = int16.empty(size(hallem_odors, 1),0);

for i = 1:size(hallem_odors, 1)
    if sum(strcmp(all_odors, hallem_odors(i,1)))    % if hallem is present in all_odors
        index = find(strcmp(all_odors, hallem_odors(i,1)));
        disp(index);
        disp(all_cids(index,1));
        hallem_cids(i, 1) = all_cids(index,1);
    else
        disp('Odor not found in all_odors');
    end
   
end
    
end

