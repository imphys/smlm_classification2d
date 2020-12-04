% eigenApproach   performs eigen analysis to optionally further group the
% classes
%
% SYNOPSIS:
%   [temp] = eigenApproach(classes_aligned,C,width)
%
% INPUT
%   classes_aligned
%       Cell arrays of classes with localization in the point field and
%       squared uncertainties in the sigma field.
%   width
%       width of the image in pixel units (crop the localizations within
%       this field-of-view)
%   C
%       number of desired classes
%
% OUTPUT
%   temp
%       Cell array containing the C classes, the result of the eigen
%       approach clustering
%
% (C) Copyright 2017               Quantitative Imaging Group
%     All rights reserved          Faculty of Applied Physics
%                                  Delft University of Technology
%                                  Lorentzweg 1
%                                  2628 CJ Delft
%                                  The Netherlands
%
% Teun Huijben, Dec 2020

function [temp] = eigenApproach(classes_aligned,C,width)

[eigenvectors,eigenvalues,weights,Im] = eigenAnalysis(width, classes_aligned);

%do k-means on the weights 
c3 = cluster(linkage(weights(:,1),'average'),'maxClust',C); 

for i = 1:C
    temp{i} = [];
    for j = find(c3==i)'
    temp{i} = [temp{i}; classes_aligned{j}.points];
    end
end

end

