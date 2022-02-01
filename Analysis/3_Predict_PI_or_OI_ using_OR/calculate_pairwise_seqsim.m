function out_table = calculate_pairwise_seqsim(seq1, seq2, output_folder)

%% calculate seqsim matrix
% seqsim = struct;
% seqsim.or1 = cell2table(cell(0,1)); seqsim.or2 = cell2table(cell(0,1)); seqsim.seqsim = cell2table(cell(0,1)); 
% 
% mat_seqsim = zeros(size(seq1,1), size(seq2,1));
% for i = 1:size(seq1,1)
%    for j = 1:size(seq2,1)
%         seqsim.or1 = [seqsim.or1; {seq1(i).Header}];
%         seqsim.or2 = [seqsim.or2; {seq2(j).Header}];
%         seqsimilarity = nwalign(seq1(i).Sequence,seq2(j).Sequence,'ScoringMatrix','BLOSUM62');
%         seqsim.seqsim = [seqsim.seqsim; {seqsimilarity}];
%         mat_seqsim(i,j) = seqsimilarity;
%    end
% end
% seqsim.or1.Properties.VariableNames = {'or1'};
% seqsim.or2.Properties.VariableNames = {'or2'};
% seqsim.seqsim.Properties.VariableNames = {'seqsim'};
% out_table = [seqsim.or1 seqsim.or2 seqsim.seqsim];
% 
% save(sprintf('%sseqsim.mat', output_folder), 'seqsim');
% save(sprintf('%smat_seqsim.mat', output_folder), 'mat_seqsim');
load(sprintf('%smat_seqsim.mat', output_folder));

%% plot heatmap
savename = 'heatmap_seqsim_agam_dmel_';
xvalues = {seq2.Header}; yvalues = {seq1.Header}; ttl = 'Sequence Similarity'; xlbl = 'Agam ORs'; ylbl = 'Dmel ORs';
% mat_seqsim(mat_seqsim > 0) = 1; mat_seqsim(mat_seqsim < 0) = -1;
plot_heatmap(mat_seqsim, xvalues, yvalues, ttl, xlbl, ylbl, savename, output_folder)

end

