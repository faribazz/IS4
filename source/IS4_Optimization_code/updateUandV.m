function [ Z3, Y3 ] = updateUandV( M1, M2, B1, B2, rho2, invh1  )
    nu2 = B1*(M1)'+ B2*(M2)'; 
    Z3 = -( (invh1)*(-M1'+ (nu2-circshift(nu2,-1,1)) ) )';
    Y3 = -( (1/rho2) *(-M2' + (nu2-circshift(nu2,-1,1)) ) )'; 
end

