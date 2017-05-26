function recruitTracker(Ioriginal,fileName,cmThreshold,c)

% image Name - this can be customized based on file name
imgName = 'outputImage';

% Make the input image 8-bit
% Ioriginal = Ioriginal./max(Ioriginal(:));
%Ioriginal = uint8(255*Ioriginal);

% size of original image
s = size(Ioriginal);

% Preprocess the images to get the mask of corals
[coralImage,stats,pixToCM,I] = preProcessImage(Ioriginal,cmThreshold,1,c);
% Display the GUI for user to interact with the mask of corals
[keepMask,rejectMask,addedMask,stats,closeFlag,skipFlag] = coralGUI(I,Ioriginal,stats,coralImage,pixToCM,imgName,1);
% Save or don't save depending on the button the user pushed
if ~skipFlag
    if ~isempty(stats)
        saveCoralData('.',fileName,imgName,stats,pixToCM,1,s,keepMask,rejectMask,addedMask,I);
    end
end



