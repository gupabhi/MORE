function out = merge_datapoints_with_same_OR_resp(data, raw_data)
% input - regression matrix
% output - merged dataset

raw_data = data_preprocessing(raw_data(:, {'odor', 'concentration', 'concentration_type', ...
                'species', 'reference', 'response'})); 

out = struct;
data_fields = fieldnames(data);

% for each species
for i = 1:size(data_fields, 1)
    
   subdata_fields = fieldnames(data.(data_fields{i})); 
   % for each concentration criteria
   for j = 1:size(subdata_fields)
       
       subdata = data.(data_fields{i}).(subdata_fields{j});
       out.(data_fields{i}).(subdata_fields{j}) = subdata; 
       out.(data_fields{i}).(subdata_fields{j})(:,:) = [];
       
       % for each odor
       odors = unique(subdata.odor);
       for k = 1:size(odors,1)

            raw_odor_data = raw_data(strcmp(raw_data.odor, odors(k)),:);
            odor_data = subdata(strcmp(subdata.odor, odors(k)),:);

            [~,~,ic] = unique(odor_data(:,1:end-4), 'rows', 'stable');      
            h = accumarray(ic, 1);  dcount = h(ic);                                  
            count_data = [odor_data, array2table(dcount)];

            out.(data_fields{i}).(subdata_fields{j}) = [out.(data_fields{i}).(subdata_fields{j}); 
                            odor_data(count_data.dcount == 1,:)];

            count_data = count_data(count_data.dcount ~= 1, 1:end-1);
            [a,~,~] = unique(count_data(:,1:end-4), 'rows', 'stable'); 
            
            for m = 1:size(a,1)
                sub_count_data = count_data(ismember(count_data(:,1:end-4),a(m,:),'rows'),:);
                conc_diffs = double.empty(size(sub_count_data{:,'concentration'},1),0);
                
                for l = 1:size(sub_count_data{:,'concentration'},1)
                    [val, ~] = min(abs(raw_odor_data{:,'concentration'} - sub_count_data{l,'concentration'}));
                    conc_diffs(l) = val;
                end
                
                [~, id] = min(conc_diffs); 
                out.(data_fields{i}).(subdata_fields{j}) = [out.(data_fields{i}).(subdata_fields{j});
                                sub_count_data(id,:)];
            end

       end
   end

end

end

