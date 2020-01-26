function [ sp, K, labelImage ] = mergeSmallRegion( roughImage, layer, sp, K,  boolMergeSmall )
    uniqueClass = unique(roughImage(:));
    [N1, N2]=size(roughImage);
    labelImage = zeros(N1, N2);
    for i = 1 : numel(uniqueClass)
        labelImage( roughImage==uniqueClass(i) ) = i;
    end

    layer = reshape(layer, N1*N2, size(layer,3));
    sizeSp = zeros( size(sp,1), 1 );
    distance = zeros( size(sp,1), 1);
    for i = 1 : size(sp,1)
        sp{i}.selfMean = mean( layer( sp{i}.index, : ), 1 );
        tempIndex = setdiff( sp{i}.dilateIndex, sp{i}.index );
        [labNeiValue,labNeiLabel] = grpstats( layer(tempIndex, :), labelImage( tempIndex ),{'mean','gname'});
        labNeiLabel = cellfun(@str2num,labNeiLabel);
        tempDiff = sum((labNeiValue - ones(numel(labNeiLabel), 1) * sp{i}.selfMean).^2, 2);
        [ val, idx ] = min(tempDiff);
        sp{i}.neighborStatus = [ val, labNeiLabel(idx) ];
        sizeSp(i) = sp{i}.area;
        distance(i) = val;
    end
    %% Merge Small Region
    A = [ [1:size(sp,1)]',  [ sizeSp, distance ] ];
    while size(A, 1)>1
        [ ~, idx]=sortrows( A(:,2:3), [ 1, 2 ] );
        i = 1;
        g = zeros(2,1);
        if A(idx(i), 2)<100
            g(2) = A(idx(i),1);
            minval = sp{g(2)}.neighborStatus(1);
            neighborTitle= sp{g(2)}.neighborStatus(2);
            if boolMergeSmall
                if A( A(:,1)==neighborTitle,2 )>500
                    A( idx(i), : ) = [];
                    continue;
                end
                if minval < 100
                    g(1) = neighborTitle;
                    % merge and update
                    [ A, sp, K, labelImage ] = updateMergeSmallRegion( sp, g, K, labelImage, layer, A );
                else
                    A( idx(i), : ) = [];
                    continue;
                end
            else
                g(1) = neighborTitle;
                % merge and update
                [ A, sp, K, labelImage ] = updateMergeSmallRegion( sp, g, K, labelImage, layer, A );
            end
        else
            A(idx(i), :)=[];
        end
    end
    tempK = arrayfun(@(x) [ repmat( x, numel(sp{x}.neighbors), 1 ), sp{x}.neighbors ], 1:size(sp,1), 'UniformOutput', false);
    K = cat( 1, tempK{:});
    K = unique( sortrows(sort(K,2)), 'rows');
    y = K(:,1)==0 | K(:,2)==0;
    K(y,:)=[];
    [sp, K] = update_sp_indexing(sp, K);
    sp = sp';
end

