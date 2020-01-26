function [ sp ] = spFeatures( sp, g, labelImage )
    [ imageRow, imageCol] = size( labelImage );
     imgDiag = sqrt( ( imageRow .^2 ) + ( imageCol .^2 ) );
     tempMat = zeros( imageRow, imageCol );
     tempMat( sp{g}.index ) = 1; 
     tempBoundary = bwboundaries(tempMat);
     sp{g}.boundaryPixel = unique( sub2ind( size( labelImage ), tempBoundary{1}( :,1 ), tempBoundary{1}( :,2 ) ) );
     sp{g}.perimeter = numel( sp{g}.boundaryPixel )/ imgDiag;
     sp{g}.label = mode( labelImage(sp{g}.index ) );
     % boundary pixels
     tempDilate = find( imdilate(tempMat, ones(3,3)) );
     tempNeighor = unique( labelImage( tempDilate) );
     sp{g}.neighbors = tempNeighor( tempNeighor ~= g );
     tempCommonBw = arrayfun( @(x) intersect( tempDilate,  sp{x}.index ), sp{g}.neighbors, 'UniformOutput' ,false );
     sp{g}.CommonBw = reshape( tempCommonBw, numel(sp{g}.neighbors), 1);
end

