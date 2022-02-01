function plot_pie(x, labels, colr, ttl, savename, output_folder)
set(0,'defaultTextInterpreter','latex');

figure;
p = pie(x,labels);
TextArr = findobj(p, 'Type','Text');                % Find ‘Text’ Objects
PatchArr = findobj(p, 'Type','patch');              % Find ‘Patch’ Objects
for k = 1:numel(PatchArr)
    Idx = contains(labels, TextArr(k).String);         % Match Strings To Index Into Color Array
    PatchArr(k).FaceColor = colr{Idx};                   % Assign Consistent Colors
end
title(ttl);

% save figure
saveas(gcf,strcat(output_folder, savename),'png')
saveas(gcf,strcat(output_folder, savename),'pdf')

close;


end

