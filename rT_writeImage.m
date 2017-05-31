function rT_writeImage(folderName,imgName, I,keepMask, rejectMask,addedMask,stats,resizeFactor,pixToCM)

overallMask = logical(keepMask) + logical(rejectMask) + logical(addedMask);
imgWithZeros = rT_setContoursToZero(I,overallMask);
% Get the relevant masks colored on the boundaries
finalMask = rT_colorCodeCorals(keepMask,rejectMask,[0 1 0],[1 0 1],addedMask,[1 1 1]);
scaleImg = rT_placeScaleBar(I,pixToCM,resizeFactor);

labelMap = rT_labelCoralsInImage(keepMask,stats,resizeFactor);
imgNew = imgWithZeros + uint8(255*finalMask) + uint8(255*labelMap) + uint8(255*scaleImg);
% Now add the legends

imwrite(imgNew, [folderName,'/',imgName,'_legendFile.jpg']);
