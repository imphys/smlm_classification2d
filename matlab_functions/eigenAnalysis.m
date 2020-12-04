% eigenAnalysis   performs eigen analysis to optionally further group the
% classes
%
% SYNOPSIS:
%   [eigenvectors, eigenvalues, weights, Im] = eigenAnalysis(width, superParticle_class)
%
% INPUT
%   superParticle_class
%       Cell arrays of particles with localization in the point field and
%       squared uncertainties in the sigma field.
%   width
%       width of the image in pixel units (crop the localizations within
%       this field-of-view)
%
% OUTPUT
%   eigenvectors
%       matrix of NxK, with N the number of pixels in the images (created
%       with 'makeImage' and K the number of classes. Each column
%       represents an reshaped eigenvector, which can be converted to an
%       eigenImage by using reshape(eigenvectors(:,1),400,400)
%   eigenvalues
%       vector of length K, with K the number of eigenvectors.
%   weights
%       matrix of KxK, with K the number of classes and eigenvectors. Each
%       row represents the weights how much each eigenvector is present in
%       each image. For example weights(2,4) is the weigth representing how
%       well the fourth eigenvector is present in the second class image.
%   Im
%       Cell array containing the nxn pixelated images of each class.
%
%
% (C) Copyright 2017               Quantitative Imaging Group
%     All rights reserved          Faculty of Applied Physics
%                                  Delft University of Technology
%                                  Lorentzweg 1
%                                  2628 CJ Delft
%                                  The Netherlands
%
% Teun Huijben, Dec 2020

function [eigenvectors, eigenvalues, weights, Im] = eigenAnalysis(width, superParticle_class )

    N=400; 
    K = length(superParticle_class);
    % convert point clouds to images 
    for i = 1:K
        I = superParticle_class{i}.points; 
    %     I = resampleCloud2D_Teun(I,numDownSamp); 
        I = makeImage(I,N,width);
%         I = imgaussfilt(I,N/30);    PUT BACK!!
        I = I-mean(I(:)); 
        I = I/norm(I(:)); 

        Im{i} = I';     
        x(:,i) = reshape(Im{i},N^2,1);

    end

    x_mean = mean(x,2);
    x = x-x_mean; 

    Cov = x'*x; 
    [U,S,~] = svd(Cov);   %A = USV'; 
       % U: columns are vectors 
       % S: diagonal are eigenvalues  
       % V: columns are vectors 

    eigenvalues = diag(S);
    eigenvectors = x*U;
    for i = 1:K
        eigenvectors(:,i) = eigenvectors(:,i)/norm(eigenvectors(:,i),2); 
    end
    weights = x'*eigenvectors; 

end


