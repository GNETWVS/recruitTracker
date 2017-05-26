
function Ibw = adaptiveThresholding2(coralMask,Ism,cmThreshold,pixToCM,resizeFactor)

% pix2CM at 100%
originalPix2CM = pixToCM/resizeFactor;

% reduce to 0.3
curPix2CM = 0.3*originalPix2CM;

sor = size(Ism);
% Whatever the original image size is, bring it to 0.3 for fast processing
% then in the end, revert back to original.
Ism = imresize(Ism,fix(0.3*[4928 7380]));
coralMask = imresize(coralMask,fix(0.3*[4928 7380]));

s = size(Ism);

G = mat2gray(Ism(:,:,2));
%G = double(G).*double(coralMask);

% clean out noisy pixels
G = imfilter(G,fspecial('Gaussian'));

% Threshold values to test: -2000, -1000, -500, -100, -20
ths = [-2000,-1000,-500,-100,-20,-10];

M = fix(length(G)/20);
Ibws = cell(numel(ths),1);
sumI = zeros(s(1),s(2));
for i = 1:numel(ths)
    curI = adaptivethresh_PK(G,M,ths(i),'gaussian','relative');
    curI = bwareaopen(curI,20);
    Ibws{i} = curI;
    sumI = sumI + curI;
end

[Ibw,~] = restrictNumberFound(sumI,numel(ths),cmThreshold,curPix2CM,coralMask);

Ibw = imresize(Ibw,[sor(1) sor(2)]);
Ibw = logical(double(Ibw).*double(imresize(coralMask,[sor(1) sor(2)])));

end

function [out,n] = restrictNumberFound(Ibw,nmax,cmThreshold,pixToCM,coralMask)
% restrict to about 10

%num = 100;
%n = 1;


diffs = zeros(nmax,1);
n = 1;
for i = 1:nmax
    sumI = Ibw > i;
    sumI = filterCoralsbySizeInImage(sumI,cmThreshold,pixToCM);
    sumI = logical(double(sumI).*double(coralMask));
    [~,num] = bwlabel(sumI);
    diffs(i) = abs(num-10);
end
% end
% while n<=nmax
%     while abs(num - 10)>6
%         if num~=0
%             sumI = Ibw > n;
%             sumI = filterCoralsbySizeInImage(sumI,cmThreshold,pixToCM);
%             sumI = logical(double(sumI).*double(coralMask));
%             [~,num] = bwlabel(sumI);
%             n = n+1;
%         else
%         end
%         
%     end
%     break
% end
out = Ibw > find(diffs==min(diffs),1);
out = filterCoralsbySizeInImage(out,cmThreshold,pixToCM);
out = logical(double(out).*double(coralMask));

end
