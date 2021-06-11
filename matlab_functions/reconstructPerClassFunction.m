% reconstructPerClassFunction   performs data fusion for a given set of particles
%
% SYNOPSIS:
%   [initAlignedParticles_class superParticle_class] = reconstructPerClassFunction(subParticles, clusters, outdir, scale, iter)
%
% INPUT
%   subParticles
%       Cell arrays of particles with localization in the point field and
%       squared uncertainties in the sigma field.
%   clusters
%       cell array, where each entry contains a vector with
%   outdir
%       Output directory where rows of all2all matrix are stored
%   scale
%       scale parameter for gmm registration
%   iter
%       number of bootstrapping iterations
%
% OUTPUT
%   initAlignedParticles_class
%       Cell array of particles in the orientation they have in the
%       superParticle
%   superParticle_class
%       Merged cell array of all aligned particles 
%
% (C) Copyright 2017               Quantitative Imaging Group
%     All rights reserved          Faculty of Applied Physics
%                                  Delft University of Technology
%                                  Lorentzweg 1
%                                  2628 CJ Delft
%                                  The Netherlands
%
% Teun Huijben, Dec 2020

function [initAlignedParticles_class, superParticle_class] = reconstructPerClassFunction(subParticles, clusters, outdir, scale, iter)

clear classResults 

%create matrix of all2all parameters 
for c = 1:length(clusters)
    members = sort(clusters{c});
    for i = 1:length(members)-1
        ii = members(i);               
        load(strcat(outdir,'/all2all_matrix/result_',num2str(ii),'.mat'))   
        for j = i+1:length(members)
            jj = members(j); 
                classResults{c}(i,j) = result(jj-ii);
        end
    end
    clear members
end

clear initAlignedParticles_class M1_class superParticle_class members  
for c = 1:length(clusters)
    disp(['start cluster: ' num2str(c)])
    %take members of class
    members{c} = sort(clusters{c});

    %convert linking indices from members to 1:Nc
    for i = 1:size(classResults{c},1)
        for j = i+1:size(classResults{c},2)
            [classResults{c}(i,j).id,~] = find(members{c}==classResults{c}(i,j).id');
        end
    end
%     
    [initAlignedParticles_class{c}, M1_class{c}] = outlier_removal_class(subParticles(members{c}),classResults{c});
    [superParticle_class{c},~] = one2all_class(initAlignedParticles_class{c},iter,M1_class{c},scale); 
end

end

