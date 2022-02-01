function pairwiseComparisonPlot_signedRankTest(data1,data2,ylabelname,xlabelname,bar1name,bar2name,color,output_filename)

% remove any pair that contains one or two NaNs
nans1 = ~isnan(data1);
nans2 = ~isnan(data2);
nansNone = and(nans1,nans2);
data1 = data1(logical(nansNone));
data2 = data2(logical(nansNone));

close all

% [h pvalue] = ttest(data1,data2);
[pvalue] = signrank(data1,data2);

x = [9 10];
xdiff = x(2)-x(1);
maxY = max(max(data1),max(data2))+std(data1)/2;
minY = min(0,min(min(data1), min(data2)));


h = area([x(1)-xdiff/4 x(1)+xdiff/4],mean(data1)*[1 1],'FaceColor',color);
set(h,'LineStyle','none');
hold on;
h = area([x(2)-xdiff/4 x(2)+xdiff/4],mean(data2)*[1 1],'FaceColor',color);
set(h,'LineStyle','none');

for i = 1:length(data1)
	
	plot(x,[data1(i) data2(i)],'color','k');
	scatter(x(1),data1(i),'Marker','.','SizeData',200,'MarkerFaceColor','k','MarkerEdgeColor','k');
	scatter(x(2),data2(i),'Marker','.','SizeData',200,'MarkerFaceColor','k','MarkerEdgeColor','k');
end
if(minY< 0)
	line([-100 100],[0 0],'LineStyle','--','color',[.7 .7 .7]);
end

xlim([x(1)-xdiff/2 x(2)+xdiff/2]);
ylim([minY, maxY]);

set(gca,'xTick',x);
set(gca,'xTickLabel',{bar1name bar2name})
img_width = 6; % inch
img_height = 7; % inch
set(gcf, 'PaperSize', [img_width img_height]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 img_width img_height]);
set(gca,'FontSize',20);
set(gca,'TickDir','out');
xlabel(xlabelname);
ylabel(ylabelname);
box off
title(['n=' num2str(length(data1)) ', p=' num2str(pvalue,'%0.1e')]);
print('-dpng','-r125', [output_filename '.png']);
% print('-dpsc2', [output_filename '.pdf']);
saveas(gcf,output_filename,'pdf')

end