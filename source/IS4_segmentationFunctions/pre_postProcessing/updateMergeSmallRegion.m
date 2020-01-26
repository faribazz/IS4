function [ A, sp, K, labelImage ] = updateMergeSmallRegion( sp, g, K, labelImage, layer, A )
    grow =g( 1 );
    die = g( 2 );

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

    sp{grow}.selfMean = mean( layer( sp{grow}.index, : ), 1 );
    tempIndex = setdiff( sp{grow}.dilateIndex, sp{grow}.index );
    [labNeiValue,labNeiLabel] = grpstats( layer(tempIndex, :), labelImage( tempIndex ),{'mean','gname'});
    labNeiLabel = cellfun(@str2num,labNeiLabel);
    tempDiff = sum((labNeiValue - ones(numel(labNeiLabel), 1) * sp{grow}.selfMean).^2, 2);
    [ val, idx ] = min(tempDiff);
    sp{grow}.neighborStatus = [ val, labNeiLabel(idx) ];
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
    %% sizeSp, distance
    A( A(:,1)==grow, 2 ) = A( A(:,1)==grow, 2 )+A( A(:,1)==die, 2 );
    A( A(:,1)==grow, 3 ) = val;
    A(A(:,1)==die,:)=[];
end

