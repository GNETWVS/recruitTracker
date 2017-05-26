function writeSpreadsheet(folderName,fileName, imgName,stats,pix2cm,resizeFactor,s)

% This script writes the statistics of the final coralMask into a text file
numManual = sum([stats.statusInd]==2);
numRejected = sum([stats.statusInd]==3);
numOriginalFound = numel(stats) - numManual;
numKept = sum([stats.keepStatus]==1);

% Column names are:

% imgFolderName:        where the images are located
% imgname:              filename of the image
% coralLabel:           ID of coral, there is also an legend image that goes with that index
% numOriginalFound:     number of corals the code automatically identified
% without user input
% numCoralsKept:        number of corals after user manually added some, or
% rejected some
% numCoralsRejected:    number of corals the user rejected
% numCoralsManuallyAdded: number of corals the user manually drew
% areaPix:                 area (in pixels) of the corals
% pixTocm:              pixel to cm conversion ratio for this image
% areaCM:               area (in cm) of the corals
% coralStatus:          found automatically, manually added, rejected
% dateSaved:            date the spreadsheet is saved

fieldNames =    ['imgName \t coralLabel \t coralStatus \t ',...
    'AreaPix^2 \t ','pixTocm \t AreaCM^2 \t',...
    'CoralsFoundInImage \t CoralsKeptInImage \t ',...
    'CoralsRejectedInImage \t CoralsManuallyAddedToImage \t',...
    'OriginalImgSize \t resizeFactor \t dateSaved \n'];

% open the file for writing
fid = fopen([folderName,'/',fileName], 'a+');
% write the column headers
fprintf(fid, fieldNames);

% Write each coral as its own row
for i = 1:numel(stats)
    AreaPix = stats(i).Area;
    AreaCM = AreaPix / pix2cm^2;
    writeStr =  [imgName,'\t',num2str(i),'\t',stats(i).status,'\t',...
        num2str(AreaPix),'\t',num2str(pix2cm), '\t',num2str(AreaCM),'\t',...
        num2str(numOriginalFound),'\t',num2str(numKept),'\t',...
        num2str(numRejected),'\t', num2str(numManual),'\t',...
        [num2str(s(1)),' x ',num2str(s(2))],'\t',num2str(resizeFactor),'\t'...
        datestr(datetime('today')),'\n'];
    fprintf(fid,writeStr);
end

% close the file!
fclose(fid);

end