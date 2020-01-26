function [ finalSegmentation ] = pre_IS4_optimization( image, initialSegmentation, multiLayer, localLayer, aveSLocal, parameters )
%=============================================================
% Prepare the data for the optimization problem 
%=============================================================
    [N1, N2, ~] = size( image );
    edgeMap = parameters.edgeMap;
    contourMap = parameters.contourMap;
    alpha = parameters.alpha;
    gamma = parameters.gamma;
    superPixels = extractingSp(initialSegmentation);
    meanOfSp = cellfun(@(x) mean(localLayer(x.index, :), 1), superPixels, 'UniformOutput' , false); meanOfSp = cat(1, meanOfSp{:});
    numOfPixelSP = cellfun( @(x) numel( x.index ), superPixels );
    numOfPixelSP = numOfPixelSP/(N1 * N2);

    L = extractingAdjacencyMatrix(multiLayer, superPixels, edgeMap, meanOfSp );
    D = cat(1, pdist2(aveSLocal, meanOfSp));
    R = D*sqrt(diag(numOfPixelSP));

    %============================================================
    % Numerical optimization
    %============================================================
    clusters = IS4_optimization(R, L, alpha, gamma); 

    %============================================================
    % Preparing final segmentation result by separating disjoint regions with the same clustering label
    %============================================================
    preSegmentation = getRoughImagefromSp(superPixels, clusters, N1, N2);
    if numel(unique( preSegmentation(:)))>2
        finalSegmentation = postProcessing(preSegmentation, contourMap, multiLayer);
        finalSegmentation = seperateRgnSameLabel(finalSegmentation);
        finalSegmentation = joinLessThan10(finalSegmentation, 20);
    else
        fprintf("Please consider choosing smaller alpha")
        finalSegmentation = initialSegmentation;
        finalSegmentation = postProcessing(finalSegmentation, contourMap, multiLayer);
    end

    finalSegmentation = sortRefindIndex(finalSegmentation);
    [ ~, colorSegment ] = displayColorSeg( im2double( image ), finalSegmentation(:) );
    figure; title('Final Segmentation'); subplot( 1, 2, 1 ); imshow( image, [] ); title('Original Image');  subplot( 1, 2, 2 ); imshow( colorSegment, [] ); title('Coherent Segments');
end