function [Z] = makeImage(X, n, diameter)
    
       %DO NOT SUBSTRACT THE MEAN! otherwise the eigenvector procedure
       %fails, because different structures get mis-aligned when they are
       %centered
       
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