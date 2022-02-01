function out = pubchem(cid, properties)
tic;

out = struct;
%% properties url
api = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/';

for i = 1:size(properties,2)
   url =  [api 'cid/' num2str(cid) '/property/' properties{i} '/TXT'];
   
   flag = 0;
   while (flag == 0)
      try
          tic;
          
          prop = webread(url);
          flag = 1;
          
          toc;
      catch ME
          
          fprintf('WEBREAD without success: %s\n', ME.message);
          flag = 0;
          
      end
   end
   
   out.(properties{i}) = prop;
   clearvars prop;
end

toc;
end

