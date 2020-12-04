% MakeMatrix   Construct the similarity matrix using the All2all result
%
% SYNOPSIS:
%   [mat,mat_norm] = MakeMatrix(outdir,subParticles,K)
%
% INPUT
%   subParticles
%       Cell arrays of particles with localization in the point field and
%       squared uncertainties in the sigma field.
%   outdir
%       Output directory where rows of all2all matrix are stored
%   K
%       number of subParticles
%
% OUTPUT
%   mat
%       similarity matrix
%   mat_norm
%       similarity matrix normalized to the number of localizations
%
% (C) Copyright 2017               Quantitative Imaging Group
%     All rights reserved          Faculty of Applied Physics
%                                  Delft University of Technology
%                                  Lorentzweg 1
%                                  2628 CJ Delft
%                                  The Netherlands
%
% Teun Huijben, Dec 2020

function [mat,mat_norm] = MakeMatrix(outdir,subParticles,K)

    %initialize
    mat = zeros(K,K);
    mat_norm = zeros(K,K);
    numLocs = zeros(1,K); 
    filled = false(K,K);     

    % fill registration matrix using resultcoords(:,1:2)
    for i=1:K-1
        load(strcat(outdir,'/all2all_matrix/result_',num2str(i),'.mat'))
        for j = 1:length(result)
            filled(i,j+i)=true; 
            mat(i,j+i)=result(j).val;    
        end
    end

    %Normalize Matrix to numLocs 
    for i = 1:K
        numLocs(i) = length(subParticles{i}.points);
    end
    for i = 1:K
        for j = 1:K
            if filled(i,j)==true
%                  if rem(i,50)==0
%             disp(i)
%         end
    %             mat_norm(i,j)=mat(i,j)/max([numLocs(i),numLocs(j)]);
                mat_norm(i,j)=mat(i,j)/(numLocs(i)*numLocs(j));       %Na*Nb
            end
        end
    end

end

