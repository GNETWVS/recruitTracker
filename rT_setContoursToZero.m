function outImg = rT_setContoursToZero(inImg,mask)

mask = logical(mask);
boundaryMask = rT_makeBoundaryMask(mask);
s = size(mask);
outImg = inImg;

for j = 1:3
    
    thisLayer = inImg(:,:,j);
    thisLayer(boundaryMask) = 0;
    outImg(:,:,j) = reshape(thisLayer,[s(1),s(2)]);
    
end
