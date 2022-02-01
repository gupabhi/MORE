% function plot_assay_vs_non_assay(data_behvr, assay, color, output_folder)
function out = plot_assay_vs_non_assay(data_behvr, assay, color, output_folder)
    
out = struct;

% round off concentration 
data_behvr.concentration = round(log10(data_behvr.concentration));

species = unique(data_behvr.species);
% Plot for a single species
if (size(species,1) == 1)
    data1 = data_behvr(strcmp(data_behvr.assay, assay), :);
    data2 = data_behvr(~strcmp(data_behvr.assay, assay), :);
    
    common_odors = intersect(unique(data1.odor), unique(data2.odor));
    if size(common_odors, 1) > 0
        mat_assay = array2table(zeros(0,2)); mat_odor = array2table(zeros(0,2));
        mat_conc = array2table(zeros(0,2)); mat_resp = array2table(zeros(0,2)); 
        mat_ref = array2table(zeros(0,2)); mat_assay2 = array2table(zeros(0,2)); 
        
        for j = 1:size(common_odors,1)
            data1_odor = data1(strcmp(data1.odor, common_odors(j)), :);
            data2_odor = data2(strcmp(data2.odor, common_odors(j)), :);

            data1_odor = merge_same_concentration_datapoints(data1_odor);
            data2_odor = merge_same_concentration_datapoints(data2_odor);
            
            common_concs = intersect(data1_odor.concentration, data2_odor.concentration);
            if size(common_concs, 2) > 0
                for k = 1:size(common_concs,1)
                    data1_odor_conc = data1_odor(data1_odor.concentration == common_concs(k), :);
                    data2_odor_conc = data2_odor(data2_odor.concentration == common_concs(k), :);
                    
                    mat_assay = [mat_assay; {data1_odor_conc.assay, data2_odor_conc.assay}];
                    mat_odor = [mat_odor; {data1_odor_conc.odor, data2_odor_conc.odor}];
                    mat_conc = [mat_conc; {data1_odor_conc.concentration, data2_odor_conc.concentration}];
                    mat_resp = [mat_resp; {data1_odor_conc.response, data2_odor_conc.response}];
                    mat_ref = [mat_ref; {data1_odor_conc.reference, data2_odor_conc.reference}];
                    mat_assay2 = [mat_assay2; {data1_odor_conc.assay, strcat('non_', data1_odor_conc.assay)}];
                end
            end
        end
        
        x = table2array(mat_conc); y = table2array(mat_resp); z = table2array(mat_assay2); 
        o = table2array(mat_odor);
        out.x = mat_conc; out.y = mat_resp; out.z = mat_assay; out.o = mat_odor;
        
        if strcmp(species, 'dmel')
            if size(x,1) > 1
                ttl = species; 
                savename = strcat(species,'_', assay, '_vs_non-', assay);
    %             savename = strcat(species,'_', assay, '_vs_non-', assay, '_wo_knaden2012_macwilliam2018');
                xlbl = ''; ylbl = 'Preference Index'; 
                o = repmat(1:size(o,1), 2,1)';
                if strcmp(assay, 't-maze')
                    z = repmat({'T-maze', 'Non-T-maze'}, size(z,1), 1);
                end
                
                plot_pairwise_assay_paired_comparison(x, y, z, o, ttl{1}, xlbl, ylbl, color, savename{1}, output_folder);
                
%                 % for positive and negative Preference index plot separately
%                 yp = y(y(:,2)>0, :); xp = x(y(:,2)>0, :); zp = z(y(:,2)>0, :); op = o(y(:,2)>0, :);
%                 plot_pairwise_assay_paired_comparison(xp, yp, zp, op, strcat(ttl{1}, '_positivePI_non-Tmaze'), xlbl, ylbl, color, ...
%                             strcat(savename{1},'_positivePI__non-Tmaze'), output_folder);
%                 
%                 yn = y(y(:,2)<=0, :); xn = x(y(:,2)<=0, :); zn = z(y(:,2)<=0, :); on = o(y(:,2)<=0, :);
%                 plot_pairwise_assay_paired_comparison(xn, yn, zn, on, strcat(ttl{1}, '_negativePI_non-Tmaze'), xlbl, ylbl, color, ...
%                             strcat(savename{1},'_negativePI_non-Tmaze'), output_folder);
%                         
%                 yp = y(y(:,1)>0, :); xp = x(y(:,1)>0, :); zp = z(y(:,1)>0, :); op = o(y(:,1)>0, :);
%                 plot_pairwise_assay_paired_comparison(xp, yp, zp, op, strcat(ttl{1}, '_positivePI_Tmaze'), xlbl, ylbl, color, ...
%                             strcat(savename{1},'_positivePI_Tmaze'), output_folder);
%                 
%                 yn = y(y(:,1)<=0, :); xn = x(y(:,1)<=0, :); zn = z(y(:,1)<=0, :); on = o(y(:,1)<=0, :);
%                 plot_pairwise_assay_paired_comparison(xn, yn, zn, on, strcat(ttl{1}, '_negativePI_Tmaze'), xlbl, ylbl, color, ...
%                             strcat(savename{1},'_negativePI_Tmaze'), output_folder);
                        
            end
        end
        
    end
    
end

end
