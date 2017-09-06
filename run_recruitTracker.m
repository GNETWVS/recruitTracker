% Main script to run recruitTracker user interface. The code is provided as
% is, but please feel free to contact the authors for questions.
%
% If you use this code, please cite the following paper:
%
% Zweifler, Adi, Derya Akkaynak, Tali Mass, and Tali Treibitz. 
% "In Situ Analysis of Coral Recruits Using Fluorescence Imaging." 
% Frontiers in Marine Science 4 (2017): 273.
%
% This code uses the export_fig toolbox. Please download from:
% https://www.mathworks.com/matlabcentral/fileexchange/23629-export-fig
%
% It also requires the Matlab Vision Toolbox. You can check if you have
% this toolbox by typing "ver" in your command line.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% Part I - Image subtraction
%
% The user to points to the white, ambient, and flourescent images,
% (which are processed using dcraw from raw images as described in the paper, 
% and converted into linear, uncompressed tiffs).
%
%
% Ask the user to specify the path of the white image
[white_im_name,white_im_path] = uigetfile('*.tiff','Please select the white image.');
% Ask the user to specify the path of the ambient image
[amb_im_name,amb_im_path] = uigetfile('*.tiff','Please select the ambient image.');
% Ask the user to specify the path of the fluorescent image
[fluo_im_name,fluo_im_path] = uigetfile('*.tiff','Please select the fluorescent image.');

tic
% Perform the image subtraction and registration
[Isubtracted, ~] = rT_mergeTrioPair([amb_im_path,amb_im_name],[white_im_path,white_im_name],[fluo_im_path,fluo_im_name]);
display('Image subtraction completed.')
toc

% Display the subtracted image
imshow(Isubtracted)
title('Result of Image Subtraction')

% Subtraction is a computationally expensive operation and takes a long
% time. Thus after every run, we save the subtracted image.

% On a 2.5 GHz intel core i7 laptop,
% If the input image is size 1534 x 1024, subtraction takes 4.4 seconds.
% If the input image is size 4912 x 7360, subtraction takes up to 10 minutes.
% Even though for large images the computation time is long, we do not recommend 
% downsampling the images because recruits are small, and
% might lose saliency if the image is downsampled.

% file name for the subtracted image to be saved
saveName = 'subtractedImage';
rT_writeFig(saveName)
% Also save a mat file.
save([saveName,'.mat'],'Isubtracted')

close
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Part II - GUI to guide user to mark corals
%
% First, some parameters:

% pix2cm:       conversion from pixels to absolute length (cm).
%
                % This can be specified by the user manually, or be automatically
                % extracted from each image using our code. However, the automatic
                % extraction code is customized to work for our dataset ONLY, which
                % contains a flourescent rope that has markings every 1cm. If your scale
                % object is different, this code will not work for you. In that case, you
                % should measure
                
% Manual Entry
pix2cm = 50; % This is a value that works for the example dataset we have provided.
             % If you are evaluating our dataset (which contains the
             % flourescent rope) and you want the code to calculate pix2cm
             % automatically, set pix2cm = 0 in the above line. This
             % variable is important because the scale bar is drawn based
             % on this. If you are evaluating your own dataset, specify
             % this value manually.

        
% cmThreshold:  Size range of major diameter of corals, outside of which they will be eliminated
                % Adjust as needed. If you are not looking for recruits,
                % you can specify a much wider range.

                cmThreshold = [0.1 5];

% c:            an rgb-lab color transform
                % This is used for more easily finding green flourescent
                % corals.
c = makecform('srgb2lab');

% outputFileName: output file name that will be saved in folder with that
% name.
outputFileName = 'coralData.txt';

% Start the coral tracking program
rT_recruitTracker(Isubtracted,outputFileName,cmThreshold,pix2cm,c);



