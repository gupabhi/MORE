% data1 - spike rate data
% data2 - current data

function plot_resp_to_common_odors(data1, data2, threshold_nA, color, output_folder)

all_ORs = double.empty(0,2);
all_ORs_txt = string.empty(0,2);
ors1 = unique(data1.or); ors2 = unique(data2.or);
ors = intersect(ors1, ors2);

for i = 1:size(ors,1)
    or = ors(i);
    or_data1 = data1(strcmp(data1.or, or),:); or_data2 = data2(strcmp(data2.or, or),:);
    common_odors = intersect(or_data1.odor, or_data2.odor);
    
    odor_data1 = sortrows(or_data1(ismember(or_data1.odor, common_odors),:), 'odor');
    odor_data2 = sortrows(or_data2(ismember(or_data2.odor, common_odors),:), 'odor');
    
    all_ORs = vertcat(all_ORs,  [odor_data1.response, odor_data2.response]);
    all_ORs_txt = vertcat(all_ORs_txt,  string([odor_data1.odor, odor_data1.or])); 
    
%     % plot for each OR
%     plot_scatter(odor_data1.response_original, odor_data2.response_original, color.g, or, ...
%             unique(odor_data1.reference), unique(odor_data2.reference),strcat('scatter_', or), output_folder, 0)

end

x = all_ORs(:,1);
y = all_ORs(:,2);

txt = cellfun(@(a, b) sprintf('(%s, %s)', a, b), ...
           all_ORs_txt(:, 1), all_ORs_txt(:, 2), 'UniformOutput', false);

       
for t = 1:size(txt, 1)
  if ~(y(t)>= threshold_nA)
      txt(t) = {''};
  end
end

% plots
title = 'All ORs';
xlabel = 'Response in empty-neuron system (spikes/s)';
ylabel = 'Response in {\it Xenopus oocyte} system (nA)';

plot_scatter(x, y, color.g, title, xlabel, ylabel,'scatter_all_ors', output_folder, 0, txt);
plot_scatter_logscale(x, y, color.g, title, xlabel, ylabel,'scatter_all_ors_log', output_folder)
    
    
%% stats
A = all_ORs(all_ORs(:,2) == 0, :);
B = all_ORs(all_ORs(:,2) ~= 0, :);

A_zero = A(A(:,1)==0, :);
B_zero = B(B(:,1)==0, :);

A_pos = A(A(:,1)>0, :);
A_neg = A(A(:,1)<0, :);

B_pos = B(B(:,1)>0, :);
B_neg = B(B(:,1)<0, :);

mean(A_zero(:,2))
median(A_zero(:,2))
size(A_zero(:,2))
std(A_zero(:,2))

mean(B_zero(:,2))
median(B_zero(:,2))
size(B_zero(:,2))
std(B_zero(:,2))

mean(A_pos(:,1))
median(A_pos(:,1))
size(A_pos(:,1))
std(A_pos(:,1))

mean(A_neg(:,1))
median(A_neg(:,1))
size(A_neg(:,1))
std(A_neg(:,1))

mean(B_pos(:,1))
median(B_pos(:,1))
size(B_pos(:,1))
std(B_pos(:,1))

mean(B_neg(:,1))
median(B_neg(:,1))
size(B_neg(:,1))
std(B_neg(:,1))

mean(abs(A(:,1)))
median(abs(A(:,1)))
size(abs(A(:,1)))
std(abs(A(:,1)))

mean(abs(B(:,1)))
median(abs(B(:,1)))
size(abs(B(:,1)))
std(abs(B(:,1)))

mean(all_ORs(:,1))
median(all_ORs(:,1))
size(all_ORs(:,1))
std(all_ORs(:,1))

 
end

