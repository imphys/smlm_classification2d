%alignClasses   Align the classes with each other
%
%   SYNOPSIS:
%       [superParticle_class] = alignClasses(subParticles, clusters, super, scale)
%
%   Input: 
%       subParticles: Cell array of particles of size 1xN, with localization in the point field and 
%       uncertainties in the sigma field.
%       clusters: cell array, where each entry contains a vector with
%       particle IDs belonging to that specific class
%       super: 
%       scale: parameter for registration
%
%   Output:
%       superParticle: the resulting fused particle
%       MT: Total transformation parameters (rotation+translation). MT is
%       an 4x4xNxiter matrix.
%       particles: aligned particles (as how they are positioned in
%       superParticle
%
%   NOTE:
%       First, the function concatenates all the particles as they are.
%       Then, each particle is extracted from the stack and registered to
%       the rest. This is done until all particles are registered to the
%       rest. Once done, the whole process is iterated iter times.

% (C) Copyright 2017                    QI Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Teun Huijben, Dec 2020.

function [superParticle_class] = alignClasses(subParticles, clusters, super, scale)

K = length(clusters); 

for i = 1:K
    members = clusters{i}';
    sigmas = [];
    for m = members
        sigmas = [sigmas; subParticles{m}.sigma];
    end
    subParticles_clustered{i}.points = super{i}{end}; 
    subParticles_clustered{i}.sigma = sigmas; 
end

len = cellfun(@(v) size(v.points,1), subParticles_clustered);
mat = zeros(K,K); 
mat_norm = zeros(K,K); 

subParticles_clustered_subsamp = subParticles_clustered;
for i = 1:K
     ind = randsample(1:len(i),min(len)); 
     subParticles_clustered_subsamp{i}.points = subParticles_clustered_subsamp{i}.points(ind,:); 
     subParticles_clustered_subsamp{i}.sigma = subParticles_clustered_subsamp{i}.sigma(ind); 
end

all2allMatrix = all2all_class(subParticles_clustered_subsamp,scale); 
[initAlignedParticles_class, M1_class] = outlier_removal_class(0,subParticles_clustered,all2allMatrix);
iter = 3; 
[~,~,superParticle_class] = one2all_class(initAlignedParticles_class,iter,M1_class,scale); 

end

