function [ layers, parameters ] = extractingImageLayers( image, parameters )
    setParametersSED;
    % Extracting edge map
    parameters.edgeMap = edgesDetect(image,model);

    % Extracting image layers
    layers = imageLayers( image );

    % Extracting contour map 
    contourMap = Gb_CSG(image, parameters.edgeMap);
    contourMap = contourMap(:, :, 1);
    contourMap(contourMap~=0) = 1;
    parameters.contourMap = contourMap;
end

