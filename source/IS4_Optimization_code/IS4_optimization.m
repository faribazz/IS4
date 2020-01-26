function [ clusters ] = IS4_optimization(R,L,alpha, gamma)
%=====================================================
% Solving the IS4 optimization problem
% R: lxn dissimilarity matrix
% L: nxn Laplacian matrix
% alpha: constant, objective hyperparameter
% gamma: constant, objective hyperparameter
%=====================================================
% Copyright @ Mohsen Kheirandishfard, 2018
%=====================================================
    R = R ./ max(max(R));
    [~, rho_max] = computeRegularizer(R,inf);
    options.rho = alpha * rho_max;
    options.mu =0.1;
    options.maxIter = 3000;
    options.errThr = 10^-6;
    options.verbose = true;
    options.cfd = ones(size(R,1),1);
    options.gamma = gamma;

    clusterCenters = [];
    k = 1;
    while( numel(clusterCenters)<3 && k<7 )
        [ Z ] = IS4_solver( R, L, options ); % Numerical Optimization
        sInd = findRepresentatives(Z);
        [clusters,clusterCenters] = findClustering(Z,sInd);
        gamma = max( 1, gamma -1); options.gamma = gamma;
        alpha = max( 0.0001, alpha-0.001 ); options.rho = alpha * rho_max;
        k=k+1;
    end
end

