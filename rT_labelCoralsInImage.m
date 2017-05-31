function labelMap = rT_labelCoralsInImage(L,stats,resizeFactor,fontSizeVal)

s = size(L);


if nargin<3
    resizeFactor = 1;
    fontSizeVal = floor(resizeFactor*50/(0.3));
elseif nargin<4
    fontSizeVal = floor(resizeFactor*50/(0.3));
end

fontSizeVal = round(max(s(1),s(2))./30);

labelMap = zeros(size(L,1),size(L,2),3);
if isstruct(stats)
    for i = 1:numel(stats)
        C = stats(i).Centroid;
        C = fixLabelsTooCloseToBorders(s,C);
        labelMap = insertText(double(labelMap),[C(1) C(2)],num2str(i),'boxopacity',0,'textcolor','w','fontsize',fontSizeVal);
    end
end
end

function C = fixLabelsTooCloseToBorders(s,C)
C = round(C);
N = round(min(s(1),s(2))/15);

finalMask = zeros(s(1),s(2));

% region1: top of image
finalMask(1:N,1:s(2)) = 1;
% region2: right
finalMask(1:s(1),end-N:end) = 2;
% region3: bottom
finalMask(s(1)-N:s(1),1:s(2)) = 3;
% region4: left
finalMask(1:s(1),1:N) = 4;

if finalMask(C(2),C(1)) == 1
    C(2) = C(2) + N;
elseif finalMask(C(2),C(1)) == 2
    C(1) = C(1) - N;
elseif finalMask(C(2),C(1)) == 3
    C(2) = C(2) - N;
elseif finalMask(C(2),C(1)) == 4
    C(1) = C(1) + N;
end



end

