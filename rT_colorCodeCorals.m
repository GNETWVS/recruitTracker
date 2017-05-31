function finalMask = rT_colorCodeCorals(keepMask,rejectMask,keepColor,rejectColor,mask,maskColor,processed,processedColor)

% This script updates the corals in the mask that is still under progress
keepMaskColor = rT_colorContours(keepMask,keepColor);
rejectMaskColor = rT_colorContours(rejectMask,rejectColor);

if nargin<5
    finalMask = keepMaskColor + rejectMaskColor;
elseif nargin<7
    maskColor = rT_colorContours(mask,maskColor);
    finalMask = keepMaskColor + rejectMaskColor + maskColor;
else
    maskColor = rT_colorContours(mask,maskColor);
    processedColor = rT_colorContours(processed,processedColor);
    finalMask = keepMaskColor + rejectMaskColor + maskColor + processedColor;
end
