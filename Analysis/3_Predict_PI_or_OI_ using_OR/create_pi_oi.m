function out = create_pi_oi(data_pi, data_oi)
out = struct;
out.resp = array2table(zeros(0,2)); out.odor = array2table(zeros(0,2)); 
out.conc = array2table(zeros(0,2)); out.species = array2table(zeros(0,2));


odors = unique(data_pi.odor);
for i = 1:size(odors,1)
    pi_odor_data = data_pi(strcmp(data_pi.odor, odors(i)), :);
    oi_odor_data = data_oi(strcmp(data_oi.odor, odors(i)), :);

    if (size(pi_odor_data, 1) > 0) && (size(oi_odor_data, 1) > 0)
        
        % first check the exact concentration matches
        [val, ia, ib]=intersect(pi_odor_data.concentration, oi_odor_data.concentration);
        if size(val,2) > 0
            for j = 1:size(val,1)
                out.odor = [out.odor; {pi_odor_data.odor(ia(j)), oi_odor_data.odor(ib(j))}];
                out.conc = [out.conc; {pi_odor_data.concentration(ia(j)), oi_odor_data.concentration(ib(j))}];
                out.resp = [out.resp; {pi_odor_data.response(ia(j)), oi_odor_data.response(ib(j))}];
                out.species = [out.species; {pi_odor_data.species(ia(j)), oi_odor_data.species(ib(j))}];
            end
            pi_odor_data(ia,:) = []; oi_odor_data(ib,:) = [];
        end
        
%         % Now check for closest concentration for remaining concentrations
%         while (size(pi_odor_data, 1) > 0) && (size(oi_odor_data, 1) > 0)
%             
%             % get closest concentration
%             [~, idx] = min(abs(log10(oi_odor_data.concentration) - log10(pi_odor_data.concentration(1))));
%             closest_conc = oi_odor_data{idx,'concentration'};
%             actual_conc = pi_odor_data.concentration(1);
%             
%             % check if closest_conc is in +-10 fold range
%             % Note: taking 0.099 because, puting 0.1 won't include 0.1, as floating 
%             %           point numbers can not be represented exactly in binary form
%             if (closest_conc/actual_conc <= 10.001) && (closest_conc/actual_conc >= 0.099) 
%                 out.odor = [out.odor; {pi_odor_data.odor(1), oi_odor_data.odor(idx)}];
%                 out.conc = [out.conc; {pi_odor_data.concentration(1), oi_odor_data.concentration(idx)}];
%                 out.resp = [out.resp; {pi_odor_data.response(1), oi_odor_data.response(idx)}];
%                 out.species = [out.species; {pi_odor_data.species(1), oi_odor_data.species(idx)}];
%                 pi_odor_data(1,:) = []; oi_odor_data(1,:) = [];
%                 
%             else
%                 pi_odor_data(1,:) = [];
%             end
%             
%         end
 
    end
    
    
end

end

