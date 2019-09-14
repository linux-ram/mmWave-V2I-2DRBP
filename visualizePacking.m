function visualizePacking(RB, data, NRsbLeftUnpacked, IndRsbLeftUnpacked, TrimLoss)

subplot(211)
r = rectangle('Position',[0 0 RB(1) RB(2)]);
r.FaceColor = [1 1 1];
r.LineWidth = 1.5;
axis([-1 RB(1)+2 -1 RB(2)+2]);

nRectSmall = size(data,1);
for iSmall = 1:nRectSmall
    r = rectangle('Position',data(iSmall,:));
    r.FaceColor = rand(1,3);
    r.LineWidth = 1.5;
end

title('Guillotine Packing','FontSize',25,'FontName','Arial','FontWeight','bold');

subplot(212)
str1 = ['Trim Loss = ' num2str(TrimLoss)];
str2 = ['Total number of RSBs: ' num2str(nRectSmall)];
str3 = [' #RSBs left unpacked = ' num2str(NRsbLeftUnpacked)];
str4 = [' Index of RSBs left unpacked = ' num2str(IndRsbLeftUnpacked)];
text(0.15,0.5,{str1,str2,str3,str4},'Color','red','FontSize',16)

axis off

end