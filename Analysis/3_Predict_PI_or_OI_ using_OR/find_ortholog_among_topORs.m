% find whether there are any ortholog among top ORs of Dmel or Agam
function find_ortholog_among_topORs(dseq, aseq, output_folder)

%% calculate pairwise sequence similarity

seqsim = calculate_pairwise_seqsim(dseq, aseq, output_folder);
load(sprintf('%sseqsim.mat', output_folder));
load(sprintf('%smat_seqsim.mat', output_folder));

end

