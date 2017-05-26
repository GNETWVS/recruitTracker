function finalMask = colorCodeCorals(keepMask,rejectMask,keepColor,rejectColor,mask,maskColor,processed,processedColor)

% This script updates the corals in the mask that is still under progress
keepMaskColor = colorContours(keepMask,keepColor);
rejectMaskColor = colorContours(rejectMask,rejectColor);

if nargin<5
    finalMask = keepMaskColor + rejectMaskColor;
elseif nargin<7
    maskColor = colorContours(mask,maskColor);
    finalMask = keepMaskColor + rejectMaskColor + maskColor;
else
    maskColor = colorContours(mask,maskColor);
    processedColor = colorContours(processed,processedColor);
    finalMask = keepMaskColor + rejectMaskColor + maskColor + processedColor;
end
