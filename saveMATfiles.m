function saveMATfiles(folderName,fileName, keepMask,rejectMask,addedMask,stats,resizeFactor,pix2CM)

% save the masks and stats
save([folderName,'/',fileName,'_masks.mat'],'keepMask','rejectMask','addedMask','stats','resizeFactor','pix2CM')