function [ layers ] = imageLayers( image )           
    % Gray Layers
    grayLayer=subImg(rgb2gray(image), fspecial('log',[3,3],0.5), fspecial('log',[5,5],0.8), fspecial('log',[7,7],1.2)); 

    % Color Layers: \Lab\Hsv
    labImage = double(rgb2lab(image));
    ycrcbImage = double(rgb2ycbcr(image));
    colorLayer = cat( 3, labImage, ycrcbImage(:,:,2:3));

    % Gradient Layers
    gradientLayer = [];
    radius = 17;
    I = imPad(image, radius, 'symmetric');
    I = rgbConvert(I,'luv');
    sigma = [0, 1.5];
    for i = 1 : 2
        if (i ==1)
            I1 = I;
        else
            f = fspecial('gaussian', radius, sigma(i));
            I1 = imfilter(I, f);
        end
        [magGradient,~] = gradientMag(I1, 0, 5, 0.01);
        magGradient = double(magGradient(radius+1:end-radius, radius+1:end-radius ) );
        gradientLayer = cat(3, gradientLayer, magGradient );
    end

    % Texton Layers
    [ textonLayer ] = malikTexton(image);

    % softSeg Layers 
    softSegLayer = softSegs(image); 
    [  ~, data1,  ~ ] = shadowedPca(reshape(softSegLayer, size(image, 1) * size(image,2), size(softSegLayer,3)));
    softSegLayer = reshape(data1(:,1:3), size(image, 1), size(image, 2), 3);
    layers = cat(3, colorLayer, grayLayer, gradientLayer,textonLayer, softSegLayer);
end

