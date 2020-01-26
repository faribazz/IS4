function [sh_mx]=LSHextraction(layers, ws)
layers=single(layers);
[N1,N2,bn]=size(layers);

ws1 = floor( ws/2 );
ws2=floor(ws/1.4);

IgRg = zeros(bn,2);
for i = 1:bn
    tmp = layers(:,:,i);
    IgRg(i,:) = [quantile(tmp(:),.99),quantile(tmp(:),.01)];
end

sh_mx1=SHcomp_givenRange(N1,N2,bn,ws1,layers,single(IgRg));
sh_mx2=SHcomp_givenRange(N1,N2,bn,ws2,layers,single(IgRg));
sh_mx=cat(1,sh_mx1,sh_mx2);
sh_mx = double(sh_mx);
sh_mx=(reshape(sh_mx,size(sh_mx,1), size(sh_mx,2)*size(sh_mx,3)))';
end



