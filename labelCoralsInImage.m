function labelMap = labelCoralsInImage(L,stats,resizeFactor,fontSizeVal)

if nargin<3
    resizeFactor = 1;
    fontSizeVal = floor(resizeFactor*50/(0.3));
elseif nargin<4
    fontSizeVal = floor(resizeFactor*50/(0.3));
end

labelMap = zeros(size(L,1),size(L,2),3);
if isstruct(stats)
    for i = 1:numel(stats)
        C = stats(i).Centroid;
        labelMap = insertText(double(labelMap),[C(1) C(2)],num2str(i),'boxopacity',0,'textcolor','w','fontsize',fontSizeVal);
    end
end

