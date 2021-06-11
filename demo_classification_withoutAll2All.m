% This code loads a dataset from the '/data' directory 
% which should be a cell array of structures called 
% subParticles with localizations in the 'point' field 
% [x,y] and SQUARED uncertainties in 'sigma' field: 
% subParticles{1}.points  -> localization data (x,y) in camera pixel units
% subParticles{1}.sigma   -> localization uncertainties (sigma) in SQUARED pixel units
% 
% The following code will load the data from file and 
% then performs the 4 (or 5) steps of the classification 
% algorithm. Different example datasets are provided, 
% both experimental as simulated data. You only need to 
% provide the 'dataset' name, and the values for K (and 
% optionally C)
%
% The code makes use of the parallel computing toolbox 
% to distribute the load over different workers. 
% 
% (C) Copyright 2017               Quantitative Imaging Group
%     All rights reserved          Faculty of Applied Physics
%                                  Delft University of Technology
%                                  Lorentzweg 1
%                                  2628 CJ Delft
%                                  The Netherlands
%
% Teun Huijben, 2020
%%  
close all
clear all
clc

path(pathdef)
% add the required directory to path
addpath(genpath('datafusion2d'))
addpath(genpath('matlab_functions'))

%% LOAD DATASET
% -- select data set ---
dataset = '200x_simulated_TUD_flame';           %100 with flame, 100 without flame (80% DoL)
% dataset = '200x_simulated_TUD_mirror';          %100 normal, 100 mirrored (80% DoL)
% dataset = '456x_experimental_TUD_mirror';     %experimental dataset of which a few (~2%) are mirrored

% -- choose number of particles --
N = 200;     %length(subparticles)

load(['data/' dataset '/subParticles.mat'])

outdir = ['output/' dataset];
if ~exist(outdir,'dir')
    mkdir(outdir);
else
    disp('Warning: outdir already exists')
end    

save([outdir '/subParticles'], 'subParticles');


%Assuming the all2all registration is already performed, we can load the
%dissimilarity matrix into our newly generated output-folder:

copy_from = ['data/' dataset '/all2all_matrix/'];
copy_to = [outdir '/all2all_matrix/'];

copyfile(copy_from, copy_to)

scale = 0.03;   
            % 0.01 for experimental TUD (in camera pixel units)
            % 0.03 for simulated TUD
            % 0.1 for NPC
            % 0.03 or Digits data
            % 0.15 for Letters data                
            % Look at Online Methods for the description

%% STEP 2: Multi-dimensional scaling

% load the similarity matrix and normalize with respect to number of localizations; 
[SimMatrix, SimMatrixNorm] = MakeMatrix(outdir,subParticles,N);  

% dissimilarity matrix
D = SimMatrixNorm+SimMatrixNorm';                   % convert upper-triangular matrix to full similarity matrix
D = max(D(:))-D;                                                     % convert to dissimilarity
D = D - diag(diag(D));                                             % set diagonal to 0
mds = mdscale(D,30,'Criterion','metricstress');     % perform multi-dimensional scaling

% show first three dimensions of MDS 
figure, scatter3(mds(:,1),mds(:,2),mds(:,3),'o','filled'), title 'Multidimensional Scaling'


%% STEP3: k-means clustering

% -- set number of classes --
K = 4;          %set to 2 for both simulated TUD datasets, this will give the correct classes
                    %set to 4 for experimental TUD dataset, and continue with STEP 5 using C=2

clus = kmeans(mds,K,'replicates',1000);
clear clusters
for i = 1:K
    clusters{i} = find(clus==i);
end

figure, scatter3(mds(:,1),mds(:,2),mds(:,3),[],clus,'o','filled'), title 'Clustering result'


%% STEP 4: Reconstruction per cluster

iters = 2;      %number of bootstraps
[~,classes] = reconstructPerClassFunction(subParticles,clusters,outdir,scale,iters);  

%% Visualize results
close all
width = 0.6; 

%random particle
ran = randi(N); 
visualizeCloud2D(subParticles{ran}.points,200,width,0,'example particle');

%fusion of all particles without classification
% visualizeCloud2D(superParticle{end},200,width,0,'superParticle');

% reconstructed clusters
for i = 1:length(classes)
    str = ['class ' num2str(i) ' (' num2str(length(clusters{i})) ' particles)' ];
    visualizeCloud2D(classes{i}{end},200,width,0,str); 
end


%% (optional) STEP 5: further clustering - Eigen image method (C<K)

% -- choose number of final classes (C<K) --
C = 2; 

classes_aligned = alignClasses(subParticles, clusters, classes, scale); 
classes_merged = eigenApproach(classes_aligned,C,width);

for i = 1:C
    visualizeCloud2D(classes_merged{i},200,width,0,['class: ' num2str(i)]);    
end






