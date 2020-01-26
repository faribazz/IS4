function [ newRefindMat ] = joinLessThan10( newRefindMat,N )
    sizeSp = arrayfun( @(x) sum( newRefindMat(:)==x ), 1:max(newRefindMat(:)), 'UniformOutput', false );
    sizeSp = cell2mat(sizeSp(:));
    sizeEdit = find( sizeSp<N );
    for i = 1 : size( sizeEdit, 1 )
        tempIndex = find(newRefindMat == sizeEdit(i));
        tempMat = zeros(size(newRefindMat, 1), size(newRefindMat, 2) );
        tempMat( tempIndex )=1;
        tempClass =unique( newRefindMat(( imdilate(tempMat, ones(3,3)) - tempMat) ==1  ) );
        tempClass = tempClass( tempClass ~= sizeEdit(i) );

        [~,myClass] = max([sizeSp(tempClass)]) ;
        myClass = tempClass(myClass(1));
        newRefindMat(tempIndex)= myClass;
    end
end

