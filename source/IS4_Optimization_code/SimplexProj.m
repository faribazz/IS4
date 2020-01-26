function X = SimplexProj(U)
    U=U';
    [m,N] = size(U);
    X = sort(U,2,'descend');
    Xtmp = (cumsum(X,2)-1)*diag(sparse(1./(1:N)));
    X = max(bsxfun(@minus,U,Xtmp(sub2ind([m,N],(1:m)',sum(X>Xtmp,2)))),0);
    X = X';
end