function [ L ] = extractingAdjacencyMatrix(layers, sp, edgeMap, LocalInfo)
    layers=single(layers);
    [N1,N2,bn]=size(layers);

    IgRg = zeros(bn,2);
    for i = 1:bn
        tmp = layers(:,:,i);
        IgRg(i,:) = [quantile(tmp(:),.99), quantile(tmp(:), 0.01)];
    end
    sh_mx=SHcomp_givenRange(N1,N2,bn,1,layers,single(IgRg));
    layers=(reshape(sh_mx,size(sh_mx,1), size(sh_mx,2)*size(sh_mx,3)))';

    spLayer = cellfun( @(x) mean(layers( x.index, : ),1), sp, 'UniformOutput' , false );
    spLayer = cat(1,spLayer{:});
    spLayer = pdist2(spLayer,spLayer);
    spLayer=exp(-1*spLayer);
    [N1, N2]= size(edgeMap);

    WLocal = pdist2(LocalInfo,LocalInfo);
    WLocal=exp(-1*3*WLocal);

    for i =1 : numel(sp)
        tempImage = zeros(N1, N2);
        tempImage(sp{i}.index)=1;
        tempDilate = imdilate(tempImage, ones(3));
        sp{i}.wholeDilate = find(tempDilate);
        sp{i}.dilate = find(tempDilate-tempImage);
    end
    W = zeros(numel(sp), numel(sp));
    for i = 1: numel(sp)
        tempImage = zeros(N1, N2);
        tempImage(sp{i}.index)=1;
        D = bwdist(tempImage);
        for j = i+1 : numel(sp)
            tempDist = sqrt(min(D(sp{j}.dilate)));
            W(i,j) = spLayer(i,j)*WLocal(i,j)*exp(-1*tempDist*0.8);
            if tempDist==0
                tempIntersect = sp{i}.wholeDilate(ismember(sp{i}.wholeDilate,sp{j}.wholeDilate));
                if ~isempty(tempIntersect)
                    temp = edgeMap(tempIntersect);
                    temp = mean(temp~=0);
                    W(i,j) = W(i,j)*exp(-1*5*temp);
                end
            end
            W(j,i)=W(i,j);
        end
    end
    L = diag(sum(W,2))-W;
end