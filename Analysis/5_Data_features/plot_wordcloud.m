function plot_wordcloud(uniqueWords, numOccurrences, ttl, savename, output_folder)
set(0,'defaultTextInterpreter','latex');

numWords = size(uniqueWords,2);
colors = rand(numWords,3);

figure;
wordcloud(uniqueWords,numOccurrences, 'Color',colors, 'MaxDisplayWords', 1000);
title(ttl);


% save figure
saveas(gcf,strcat(output_folder, savename),'png')
saveas(gcf,strcat(output_folder, savename),'pdf')

close;
end

