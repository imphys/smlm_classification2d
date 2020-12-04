% makeImage   create image from localization coordinates by binning the
% localizations.
%
% SYNOPSIS:
%   [Z] = makeImage(X, n, diameter)
%
% INPUT
%   X
%       Nx2 matrix containing the localization coordinates. The x-values in
%       the first column and y-values in the second column
%   n
%       Number of pixels in the nxn output image
%   diameter
%       width of the image in pixel units (crop the localizations within
%       this field-of-view)
%
% OUTPUT
%   nxn matrix representing the image. Note: the localizations are
%   deliberately not centered around zero, otherwise the EigenAnalysis does
%   not work anymore, because then different classes are no longer alinged.
%
% (C) Copyright 2017               Quantitative Imaging Group
%     All rights reserved          Faculty of Applied Physics
%                                  Delft University of Technology
%                                  Lorentzweg 1
%                                  2628 CJ Delft
%                                  The Netherlands
%
% Teun Huijben, Dec 2020

function [Z] = makeImage(X, n, diameter)
       
    % extract the ROI
    ROIradius = 0.5*diameter;
    X = X(find(X(:,1) < ROIradius & X(:,1) > (-ROIradius)),:);
    X = X(find(X(:,2) < ROIradius & X(:,2) > (-ROIradius)),:);

    % define the grid
    xi = linspace(-ROIradius,ROIradius,n);
    yi = linspace(-ROIradius,ROIradius,n);

    % discretize the particle coordinates
    xr = interp1(xi,1:numel(xi),X(:,1),'nearest');
    yr = interp1(yi,1:numel(yi),X(:,2),'nearest');

    % binning
    Z = accumarray([xr yr],1, [n n]);
    
end