% Main script to run recruitTracker interface
%
% If you use this code, please cite the following paper:
%
% Zweifler et al.........
% *** ADI PLEASE FILL IN YOUR CITATION HERE ****
% *** when you have it **************
%
%
% This code also uses the export_fig toolbox from:
% https://www.mathworks.com/matlabcentral/fileexchange/23629-export-fig
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The user to points to the white, ambient, and flourescent images,
% (which are processed from raw images as described in the paper).
%

% Part I - Image subtraction
%
% Get the path of the white image
[white_im_name,white_im_path] = uigetfile('*.png','Please select the white image.');
% Get the path of the ambient image
[amb_im_name,amb_im_path] = uigetfile('*.png','Please select the ambient image.');
% Get the path of the fluorescent image
[fluo_im_name,fluo_impath] = uigetfile('*.png','Please select the fluorescent image.');

% Perform the image subtraction and registration
[Isubtracted, ~] = mergeTrioPair([amb_im_path,amb_im_name],[white_im_path,white_im_name],[fluo_im_path,fluo_im_name]);
display('Image subtraction completed.')

%%
close
% Part II - GUI to guide user to mark corals
%
% First, some parameters:
%
% cmThreshold: Size range of major diameter of corals, outside of which they will be eliminated
% Adjust as needed.
cmThreshold = [0.1 2.5];
% c: an rgb-lab color transform
c = makecform('srgb2lab');

% output file name that will be saved in folder "outputFileName"
outputFileName = 'coralData.txt';

% Start the coral tracking program
recruitTracker(Isubtracted,outputFileName,cmThreshold,c);



