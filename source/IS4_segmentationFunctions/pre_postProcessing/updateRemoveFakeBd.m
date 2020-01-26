function [ K, comm_val, diff_val, labelImage, sp ] = updateRemoveFakeBd( sp, g, K, comm_val, diff_val, labelImage, longContourPixel )
    Area = [ sp{g(1)}.area, sp{g(2)}.area ];
    grow =g( Area == max(Area) );
    die = g( Area==min(Area) );

    sp{grow}.index = [sp{grow}.index; sp{die}.index];
    %% grow
    [N1, N2]=size(labelImage);
    labelImage( sp{grow}.index ) = grow;
    tempMat = labelImage==grow;
    tempBoundary = bwboundaries(tempMat, 8);
    sp{grow}.boundaryPixel = unique( sub2ind( [N1, N2], tempBoundary{1}( :,1 ), tempBoundary{1}( :,2 ) ) );
    sp{grow}.perimeter = numel( sp{grow}.boundaryPixel );

    tempDilate = imdilate(tempMat, ones(3,3));
    tempIndex = tempDilate & ~ tempMat;
    tempNeighor = unique( labelImage( tempIndex) );
    sp{grow}.neighbors = tempNeighor( tempNeighor ~= grow );
    sp{grow}.dilateIndex = find(tempDilate);
    sp{grow}.area = numel(sp{grow}.index);
    %% die Grow Neighbors
    for t = sp{grow}.neighbors'
        temp = sp{t}.neighbors';
        sp{t}.neighbors = [grow, temp(temp ~= grow & temp ~= die)]';
    end
    %% die
    sp{die}.index = [];
    sp{die}.area = 0;
    sp{die}.neighbors = 0;
    %% K
    y = K(:,1) == grow | K(:,1) == die | K(:,2) == grow | K(:,2) == die;
    K(y,:) = [];

    K_new = [grow*ones(length(sp{grow}.neighbors),1), sp{grow}.neighbors];
    K = [K; K_new];
    %% comm_val, diffVal
    comm_val(y)=[];
    diff_val(y)=[];
    new_diff_val = zeros(size(K_new,1),1);
    new_comm_val = zeros(size(K_new, 1),1);
    for i = 1 : size(K_new,1)
        combndry = intersect( sp{K_new(i,1)}.dilateIndex, sp{K_new(i,2)}.dilateIndex );
        den = numel(combndry)/2;
        nom = intersect( combndry, longContourPixel );
        new_diff_val(i) = numel(nom)/den;
        new_comm_val(i) = den/min([ sp{K_new(i,1)}.perimeter, sp{K_new(i,2)}.perimeter]);
    end
    comm_val=[ comm_val; new_comm_val ];
    diff_val=[ diff_val; new_diff_val ];
    %%
    [~,order_idx] = sort(comm_val(:),'descend');
    comm_val = comm_val(order_idx);
    diff_val= diff_val(order_idx);
    K=K(order_idx, :);
end

