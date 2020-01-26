function [ Z2  ] = IS4_solver( R, L, options )
%=====================================================
% Numerical Optimization for solving IS4 
% R: lxn dissimilarity matrix
% L: nxn  Laplacian matrix
% options:
%               gamma: constant, objective hyperparameter
%               mu: constant, augmented Lagrangian hyperparameter
%               rho: constant, objective hyperparameter = alpha * rho_max;
%               maxIter:  constant, maximum iteration
%               errThr: constant, convergence criteria
%=====================================================
% Copyright @ Mohsen Kheirandishfard, 2018
%=====================================================
    % Initialization:
    gamma = options.gamma;
    rho1 = options.mu;
    rho2 = options.mu;
    epInf = options.rho;
    maxIteration = options.maxIter;
    threshold = options.errThr;
    [d, N] = size(R);

    tempCircR = triu(ones(N),-1)-triu(ones(N),0); tempCircR(1,N)=1;
    X = (eye(N)-tempCircR);
    invh1 = inv(2*gamma*L + rho1*eye(N));
    blockAinvHA = pinv( X*(invh1)*X' + (1/rho2).*(X*X'));
    B1 = (blockAinvHA * X)* (invh1);
    B2 = (1/rho2).* blockAinvHA * X;

    Cy2 = zeros( d, N );
    Cz2 = zeros( d, N );
    Lambda1 = zeros(d,N);
    Lambda2 = zeros(d,N);
    k  =1;
    terminate_ADMM = false;
    while ( ~terminate_ADMM )
        M1 = Cz2-(Lambda1+R)./rho1; M2 = Cy2-Lambda2./rho2;
        % subproblem 1
        [Z1, Y1] = updateUandV( rho1*M1-(epInf/N), rho2*M2-(epInf/N), B1, B2, rho2, invh1  );

        % subproblem 2
        M1 =Z1+Lambda1./rho1;
        Z2 = SimplexProj(M1);
        Y2 = Y1 + ( Lambda2 ./ rho2 ); Y2(Y2<0)=0;

        % updates
        Lambda1 = Lambda1 + rho1 * ( Z1 - Z2 );
        Lambda2 = Lambda2 + rho2 * ( Y1 - Y2 );

        err1 = errorCoef(Z1,Z2);
        err2 = errorCoef(Z2,Cz2);
        err3 = errorCoef(Y1,Y2);
        err4 = errorCoef(Y2,Cy2);   
        if ( k >= maxIteration || (err1 <= threshold && err2 <= threshold  && err3 <= threshold && err4 <= threshold) )
            terminate_ADMM = true;
        end
        Cy2 = Y2;
        Cz2 = Z2;
        k = k + 1;
    end
end

