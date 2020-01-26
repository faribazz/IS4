function [ F3 ] = malikTexton( image )
    [ F ] = malikFilter(  );
    gray = double(rgb2gray(image )) ;
    myFilter = zeros(size(image, 1), size(image, 2), size(F, 3 ) );
    for i = 1 : size(F, 3)
        myFilter(:, :, i)= imfilter( gray, F(:,:,i) );
    end
    F2 = reshape( myFilter, size(image, 1)*size(image, 2) , size(myFilter,3) );
    F3 = max(F2, [], 2);
    F3 = reshape( F3,  size(image, 1), size(image, 2) );
end

