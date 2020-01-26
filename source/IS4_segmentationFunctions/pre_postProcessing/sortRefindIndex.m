function [ newRefindMat ] = sortRefindIndex( newRefindMat )
    tempSegs = zeros(size(newRefindMat,1), size(newRefindMat, 2));
    tempClass = unique( newRefindMat(:) ) ;
    for i = 1 : numel( tempClass )
       tempSegs(  newRefindMat(:) == tempClass(i)  ) = i;
    end
    newRefindMat = tempSegs;
end

