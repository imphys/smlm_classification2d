function [eigenvectors, eigenvalues, weights, Im] = eigenAnalysis(width, superParticle_class_fromSP )

    N=400; 
    K = length(superParticle_class_fromSP);
    % convert point clouds to images 
    for i = 1:K
        I = superParticle_class_fromSP{i}.points; 
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


