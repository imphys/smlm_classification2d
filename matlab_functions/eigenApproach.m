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

