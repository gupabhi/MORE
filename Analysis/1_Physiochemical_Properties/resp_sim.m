% plot the graph between similarity coefficients and response spectrum
function resp_sim(data, scatter_dot_size, a_color, d_color, resp_col_range, output_folder)

mkdir(sprintf('%sresp_sim', output_folder));
output = sprintf('%sresp_sim/', output_folder);

%% Carey2010
idata = data.carey; % input data
carey_smile = idata.smile;
carey_resp = idata(:, resp_col_range(1):resp_col_range(2));
out_carey = struct;
all_odor_pairs = nchoosek(1:size(idata,1),2);

for i = 1:size(all_odor_pairs, 1)
    disp(i)
    smile1 = carey_smile(all_odor_pairs(i,1));
    smile2 = carey_smile(all_odor_pairs(i,2));
    [tanimoto(i), dice(i)] = sim_coeff(smile1{1}, smile2{1}); 

    resp1 = table2array(carey_resp(all_odor_pairs(i,1), :));
    resp2 = table2array(carey_resp(all_odor_pairs(i,2), :));
    dist(i) = norm(resp1 - resp2); % euclidean distance
    
end
out_carey.tanimoto = tanimoto;
out_carey.dice = dice;
out_carey.dist = dist;
save(sprintf('%sout_carey.mat', output),'out_carey');

save_name = 'Carey2010_AGam_tanimoto_dist';
Title = 'AGam_Tanimoto'; x_label = 'Tanimoto Coefficient'; y_label = 'Euclidean Distance';
scatter_plot(out_carey.tanimoto', out_carey.dist', scatter_dot_size, a_color, Title, x_label, y_label, save_name, output)

save_name = 'Carey2010_AGam_dice_dist';
Title = 'AGam_Dice'; x_label = 'Dice Coefficient'; y_label = 'Euclidean Distance';
scatter_plot(out_carey.dice', out_carey.dist', scatter_dot_size, a_color, Title, x_label, y_label, save_name, output)

%% Hallem2006
idata = data.hallem; % input data
hallem_smile = idata.smile;
hallem_resp = idata(:, resp_col_range(1):resp_col_range(3));
out_hallem = struct;
all_odor_pairs = nchoosek(1:size(idata,1),2);

for i = 1:size(all_odor_pairs, 1)
    disp(i)
    smile1 = hallem_smile(all_odor_pairs(i,1));
    smile2 = hallem_smile(all_odor_pairs(i,2));
    [tanimoto(i), dice(i)] = sim_coeff(smile1{1}, smile2{1}); 

    resp1 = table2array(hallem_resp(all_odor_pairs(i,1), :));
    resp2 = table2array(hallem_resp(all_odor_pairs(i,2), :));
    dist(i) = norm(resp1 - resp2); % euclidean distance
    
end
out_hallem.tanimoto = tanimoto;
out_hallem.dice = dice;
out_hallem.dist = dist;
save(sprintf('%sout_hallem.mat', output),'out_hallem');

save_name = 'Hallem2006_DMel_tanimoto_dist';
Title = 'DMel_Tanimoto'; x_label = 'Tanimoto Coefficient'; y_label = 'Euclidean Distance';
scatter_plot(out_hallem.tanimoto', out_hallem.dist', scatter_dot_size, d_color, Title, x_label, y_label, save_name, output)

save_name = 'Hallem2006_AGam_dice_dist';
Title = 'DMel_Dice'; x_label = 'Dice Coefficient'; y_label = 'Euclidean Distance';
scatter_plot(out_hallem.dice', out_hallem.dist', scatter_dot_size, d_color, Title, x_label, y_label, save_name, output)

end
