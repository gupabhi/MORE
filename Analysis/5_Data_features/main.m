%%  plot all the graphs showing the features of the dataset
clear; clc; format longg; close;

%% Initializing variables
color.r = [0.96 0.37 0.59]; color.g = [0.3 1 0.3]; color.b = [0.4 0.6 1];
color.y = [1 1 0.4]; color.p = [0.86 0.6 1]; color.o = [1 0.6 0.4];
output_folder = './output/';

%% load structured data
input_file = './input/2020_04_08_structured_dataset.xlsx';
% input_file = './input/2021_11_22_structured_dataset.xlsx';

mos_behvr = read_excelsheet(input_file, 'Mos_Behaviour', 'mos_behvr', './input/');
% mos_or = read_excelsheet(input_file, 'Mos_OR', 'mos_or', './input/');
% mos_or_current = read_excelsheet(input_file, 'Mos_OR_Current', 'mos_or_current', './input/');
% mos_ovi = read_excelsheet(input_file, 'Mos_Oviposition', 'mos_oviposition', './input/');
% mos_eag = read_excelsheet(input_file, 'Mos_EAG', 'mos_eag', './input/');
% mos_ssr = read_excelsheet(input_file, 'Mos_SSR', 'mos_ssr', './input/');
% dmel_behvr = read_excelsheet(input_file, 'DMel_Behaviour','dmel_behvr', './input/');
% dmel_or = read_excelsheet(input_file, 'DMel_OR', 'dmel_or', './input/');
% dmel_ovi = read_excelsheet(input_file, 'DMel_Oviposition', 'dmel_oviposition', './input/');

load('./input/mos_behvr.mat'); load('./input/mos_or.mat'); load('./input/mos_or_current.mat');
load('./input/mos_oviposition.mat'); load('./input/mos_eag.mat'); load('./input/mos_ssr.mat');
load('./input/dmel_behvr.mat'); load('./input/dmel_or.mat'); load('./input/dmel_oviposition.mat');

data.mos.mos_behvr = mos_behvr; data.mos.mos_or = mos_or; data.mos.mos_or_current = mos_or_current;
data.mos.mos_ovi = mos_oviposition; data.mos.mos_eag = mos_eag; data.mos.mos_ssr = mos_ssr; 
data.dmel.dmel_behvr = dmel_behvr; data.dmel.dmel_or = dmel_or;  data.dmel.dmel_ovi = dmel_oviposition;

% read reference sheet
references = readtable(input_file, 'Sheet', 'References', 'ReadVariableNames',false);
references.Properties.VariableNames = {'Specie'	'Reference'	'Detailed Reference' 'Remarks'};
references.Reference = cell(references.Reference);
save(sprintf('%s%s.mat', './input/', 'references'));
load('./input/references.mat');


%% find number of datapoints for each assay
% data_assays = categorical(mos_behvr.assay);
% assays = unique(data_assays);
% [cnt_unique, unique_assays] = hist(data_assays,unique(data_assays));
% 
% % remove larval data
% larval_idx = find(strcmp(lower(unique_assays), 'larval'));
% cnt_unique(larval_idx) = [];
% unique_assays(larval_idx) = [];
% 
% % change count with percentage
% cnt_unique_percentage = num2cell((cnt_unique/sum(cnt_unique))*100);
% 
% vertcat(cnt_unique_percentage, unique_assays);

%% WordCloud - # odor datapoints
% mosquitoes
mos_odors = lower([data.mos.mos_behvr.odor; data.mos.mos_or.odor; data.mos.mos_or_current.odor; ...
                data.mos.mos_ovi.odor;  data.mos.mos_eag.odor; data.mos.mos_ssr.odor]);
            
[mos_numOccurrences,mos_uniqueWords] = histcounts(categorical(mos_odors));
% plot_wordcloud(mos_uniqueWords, mos_numOccurrences, 'mosquitoes odor frequency', ...
%             'wordcloud_odor_frequency_mos', output_folder)

% dmel
dmel_odors = lower([data.dmel.dmel_behvr.odor; data.dmel.dmel_or.odor; data.dmel.dmel_ovi.odor;]);
            
[dmel_numOccurrences,dmel_uniqueWords] = histcounts(categorical(dmel_odors));
% plot_wordcloud(dmel_uniqueWords, dmel_numOccurrences, 'dmel odor frequency', ...
%             'wordcloud_odor_frequency_dmel', output_folder)

[allOdors_numOccurrences,allOdors_uniqueWords] = histcounts(categorical([mos_odors; dmel_odors]));

% Get top 10 odors
[top_values, top_idx] = sort(allOdors_numOccurrences, 'descend');
top10_odors = vertcat(string(allOdors_numOccurrences(top_idx(1:10))),allOdors_uniqueWords(top_idx(1:10))); 

plot_wordcloud(allOdors_uniqueWords, allOdors_numOccurrences, 'odor frequency', ...
            'wordcloud_odor_frequency', output_folder)

T = cell2table([num2cell(allOdors_numOccurrences'), allOdors_uniqueWords']); 
T.Properties.VariableNames = {'Weight', 'Word'};
writetable(T,'./input/WordCloud_odors.csv');

%% ------get relevant input values for bar and pie charts--------------

%% number of datapoints per species
% all_species_datapoints = cellstr([data.mos.mos_behvr.species; data.mos.mos_or.species; data.mos.mos_or_current.species; ...
%     data.mos.mos_ovi.species; data.mos.mos_eag.species; data.mos.mos_ssr.species; ...
%     data.dmel.dmel_behvr.species; data.dmel.dmel_or.species; data.dmel.dmel_ovi.species]);
% 
% species = unique(all_species_datapoints);
% for k=1:numel(species)
%   freq(k) = sum(strcmp(all_species_datapoints,species(k)));
% end
% num_datapoints_per_species = [species num2cell(freq')];
% 
% save('./output/num_datapoints_per_species.mat', 'num_datapoints_per_species');
% load('./output/num_datapoints_per_species.mat');

%% number of datapoints per datatype
% datapoints_OR = cellstr([data.mos.mos_or.species; data.mos.mos_or_current.species; data.dmel.dmel_or.species]);
% datapoints_SSR = cellstr([data.mos.mos_ssr.species]);
% datapoints_Behavior = cellstr([data.mos.mos_behvr.species; data.dmel.dmel_behvr.species; ...
%     data.mos.mos_ovi.species; data.dmel.dmel_ovi.species]);
% datapoints_EAG = [data.mos.mos_eag.species];

%% number of research articles per species
% all_species_datapoints = cellstr([data.mos.mos_behvr.species; data.mos.mos_or.species; data.mos.mos_or_current.species; ...
%     data.mos.mos_ovi.species; data.mos.mos_eag.species; data.mos.mos_ssr.species; ...
%     data.dmel.dmel_behvr.species; data.dmel.dmel_or.species; data.dmel.dmel_ovi.species]);
% 
% all_ref_datapoints = cellstr([data.mos.mos_behvr.reference; data.mos.mos_or.reference; data.mos.mos_or_current.reference; ...
%     data.mos.mos_ovi.reference; data.mos.mos_eag.reference; data.mos.mos_ssr.reference; ...
%     data.dmel.dmel_behvr.reference; data.dmel.dmel_or.reference; data.dmel.dmel_ovi.reference]);
% 
% species = unique(all_species_datapoints);
% 
% variable_names_types = [["species", "string"]; ["num_papers", "double"]];
% 
% % Make table using fieldnames & value types from above
% num_papers_per_species = table('Size',[0,size(variable_names_types,1)],... 
% 	'VariableNames', variable_names_types(:,1),...
% 	'VariableTypes', variable_names_types(:,2));
% 
% 
% for i = 1:size(species,1)
%     idx = strcmp(all_species_datapoints, species(i));
%     num_papers_per_species = [num_papers_per_species; {species(i), size(unique(all_ref_datapoints(idx)),1)}];
% end
% 
% save('./output/num_papers_per_species.mat', 'num_papers_per_species');
% load('./output/num_papers_per_species.mat');

%% number of datapoints per sensillum type
% mos_sensillum_type = lower(data.mos.mos_ssr.sensillum_type);
% 
% [numOccurrences,uniqueWords] = histcounts(categorical(mos_sensillum_type));
% T = cell2table([uniqueWords; num2cell(numOccurrences)]); 
% 
% num_datapoints = num2cell(numOccurrences);
% sensillumType = uniqueWords;
% num_datapoints_per_sensillumType = vertcat(sensillumType, num_datapoints);
% 
% save('./output/num_datapoints_per_sensillumType.mat', 'num_datapoints_per_sensillumType');
% load('./output/num_datapoints_per_sensillumType.mat');

%% number of articles per EAG preparationType
% mos_eag_prep_type = lower(data.mos.mos_eag.preparation_type);
% mos_eag_prep_type_ref = lower(data.mos.mos_eag.reference);
% 
% prep_type = unique(mos_eag_prep_type); num_papers = [];
% for i = 1:size(prep_type,1)
%     num_papers = [num_papers; size(unique(mos_eag_prep_type_ref(strcmp(mos_eag_prep_type, prep_type(i)))),1)];
% end
% 
% num_papers_per_eagType = horzcat(prep_type, num2cell(num_papers));
% 
% save('./output/num_papers_per_eagType.mat', 'num_papers_per_eagType');
% load('./output/num_papers_per_eagType.mat');

%% number of papers per year
% ref = references.Reference;
% year_published = cellfun(@(x) regexp(x, '\d+', 'match'), ref, 'UniformOutput', false);
% year_published = cellfun(@(x)str2double(x), year_published);
% 
% [numOccurrences,uniqueWords] = histcounts(categorical(year_published));
% num_papers_per_year = [cellfun(@(x)str2double(x), uniqueWords); numOccurrences]; 
% 
% % get values in the year-range
% yearRange = array2table([[1976 1980]; [1981 1985]; [1986 1990]; [1991 1995]; [1996 2000]; ...
%         [2001 2005]; [2006 2010]; [2011 2015]; [2016 2020]]);
% yearRange.Properties.VariableNames = {'lower', 'upper'};
% 
% num_paper = []; year = [];
% for i = 1:size(yearRange,1)
%     count = 0;
%     for j = 1:size(num_papers_per_year,2)
%         yr = num_papers_per_year(1,j); 
%         if (yearRange.upper(i) >= yr)  && (yearRange.lower(i) <= yr)
%             count = count + num_papers_per_year(2,j);
%         end
%     end
%     num_paper = [num_paper; count];
%     year = [year; strcat(num2str(yearRange.lower(i)), '-', num2str(yearRange.upper(i)))];
% end
% num_papers_vs_year.num_paper = num_paper;
% num_papers_vs_year.year = categorical(cellstr(year));
%     
% % plot bar
% x = num_papers_vs_year.year; y = num_papers_vs_year.num_paper;
% ylbl = 'Number of papers'; xlbl = 'Year';
% plot_bar(x', y', color.b, '', xlbl, ylbl,'bar_papers_year', output_folder);

%% number of papers vs Age (both behavioral & electrophysiology - mosquitoes)
% % get num_papers for each age
% mos_age_behvr_ref = data.mos.mos_behvr.reference;
% mos_age_behvr = str2double(data.mos.mos_behvr.age);
% mos_age_behvr_ref = mos_age_behvr_ref(~isnan(mos_age_behvr));
% mos_age_behvr = mos_age_behvr(~isnan(mos_age_behvr));
% 
% ages_behvr = unique(mos_age_behvr); num_papers_behvr = zeros(size(ages_behvr));
% for i = 1:size(ages_behvr)
%     num_papers_behvr(i) = size(unique(mos_age_behvr_ref(mos_age_behvr == ages_behvr(i))),1);
% end
% 
% num_papers_per_age_behvr = [ages_behvr, num_papers_behvr];
% 
% 
% mos_age_electrophysiology_ref = [data.mos.mos_eag.reference; data.mos.mos_ssr.reference; ...
%     data.mos.mos_or.reference; data.mos.mos_or_current.reference];
% mos_age_electrophysiology = str2double([data.mos.mos_eag.age; data.mos.mos_ssr.age; data.mos.mos_or.age; ...
%                 data.mos.mos_or_current.age]);
% mos_age_electrophysiology_ref = mos_age_electrophysiology_ref(~isnan(mos_age_electrophysiology));
% mos_age_electrophysiology = mos_age_electrophysiology(~isnan(mos_age_electrophysiology));
% 
% ages_electrophysiology = unique(mos_age_electrophysiology); num_papers_electrophysiology = zeros(size(ages_electrophysiology));
% for i = 1:size(ages_electrophysiology)
%     num_papers_electrophysiology(i) = size(unique(mos_age_behvr_ref(mos_age_behvr == ages_electrophysiology(i))),1);
% end
% 
% num_papers_per_age_electrophysiology = [ages_electrophysiology, num_papers_electrophysiology];
% 
% % get values in the age-range
% upperBound = max(max(num_papers_per_age_behvr(:,1)), max(num_papers_per_age_electrophysiology(:,1)));
% upperBound = upperBound + rem(upperBound,2);
% lowerBound = min(min(num_papers_per_age_behvr(:,1)), min(num_papers_per_age_electrophysiology(:,1)));
% lowerBound = floor(lowerBound);
% 
% a = lowerBound:2:upperBound; ageRange = [];
% for i = 1:(size(a, 2) - 1)
%     ageRange = [ageRange; [a(i) a(i+1)]];
% end
% ageRange = array2table(ageRange);
% ageRange.Properties.VariableNames = {'lower', 'upper'};
% 
% num_paper_behvr = []; age = {}; num_paper_electrophysiology = [];
% for i = 1:size(ageRange,1)
%     age{end+1} = strcat(num2str(ageRange.lower(i)), '-', num2str(ageRange.upper(i)));
% 
%     % behavioural
%     count1 = 0;
%     for j = 1:size(num_papers_per_age_behvr,1)
%         a = num_papers_per_age_behvr(j,1); 
%         if (ageRange.upper(i) > a)  && (ageRange.lower(i) <= a)
%             count1 = count1 + num_papers_per_age_behvr(j,2);
%         end
%     end
%     
%     num_paper_behvr = [num_paper_behvr; count1];
%     
%     % electrophysiology
%     count2 = 0;
%     for j = 1:size(num_papers_per_age_electrophysiology,1)
%         a = num_papers_per_age_electrophysiology(j,1); 
%         if (ageRange.upper(i) > a)  && (ageRange.lower(i) <= a)
%             count2 = count2 + num_papers_per_age_electrophysiology(j,2);
%         end
%     end
%     
%     num_paper_electrophysiology = [num_paper_electrophysiology; count2];
%     
% end
% num_papers_with_age.behavioral = num_paper_behvr;
% num_papers_with_age.electrophysiology = num_paper_electrophysiology;
% num_papers_with_age.age = categorical(cellstr(age'));
% 
% x = categorical(repmat(num_papers_with_age.age', 1,2)'); 
% y = [num_papers_with_age.behavioral; num_papers_with_age.electrophysiology];
% z = repmat({'Behavioural', 'Electrophysiology'}, size(num_papers_with_age.behavioral)); z = z(:);
% 
% ylbl = 'Number of papers'; xlbl = 'Age'; ttl = '';
% plot_bar2(x, y, z, ttl, xlbl, ylbl, 'bar_papers_age', output_folder)

%% number of articles per behavioral assay type (mosquitoes & drosophila)
% % mosquitoes
% mos_assay_behvr = lower(data.mos.mos_behvr.assay);
% mos_assay_behvr_ref = lower(data.mos.mos_behvr.reference);
% 
% mos_assay_type = unique(mos_assay_behvr); mos_num_papers = [];
% for i = 1:size(mos_assay_type)
%    mos_num_papers =  [mos_num_papers; size(unique(mos_assay_behvr_ref(strcmp(mos_assay_behvr,...
%         mos_assay_type(i)))),1)];
% end
% mos_numPaper_assayType = horzcat(cellstr(mos_assay_type), num2cell(mos_num_papers));

% % dmel
% dmel_assay_behvr = lower(data.dmel.dmel_behvr.assay);
% dmel_assay_behvr_ref = lower(data.dmel.dmel_behvr.reference);
% dmel_assay_type = unique(dmel_assay_behvr); dmel_num_papers = [];
% for i = 1:size(dmel_assay_type)
%    dmel_num_papers =  [dmel_num_papers; size(unique(dmel_assay_behvr_ref(strcmp(dmel_assay_behvr,...
%         dmel_assay_type(i)))),1)];
% end
% 
% dmel_numPaper_assayType = horzcat(cellstr(dmel_assay_type), num2cell(dmel_num_papers));


