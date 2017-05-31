function rT_writeSkippedFiles(folderName,imgName)

% open the file for writing
fid = fopen([folderName,'/skippedFiles.txt'], 'a+');
% write the column headers
fprintf(fid, [imgName,'\t',datestr(datetime('today')),'\n']);
fclose(fid);

% Write a confirmation message
display(['Added ',imgName,' to skipped list.'])
