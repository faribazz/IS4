function [labelImage ] = postProcessing(roughImage, contourMap, multiLayer)
    [ labelImage ] = avoidLeakage(contourMap, roughImage);
    [ labelImage, SP, K ] = postProcessingFeatureExtraction(labelImage, contourMap, 0.5, 0.1);
    [ ~, ~, labelImage ] = mergeSmallRegion(labelImage, multiLayer, SP, K, 1);
    [ labelImage, SP, K ] = postProcessingFeatureExtraction(labelImage, contourMap, 0.25, 0.1);
    [ ~, ~, labelImage ] = mergeSmallRegion(labelImage, multiLayer, SP, K, 0);
end

