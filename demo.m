clc
clear all
close all
%% Parameters
parameters.alpha = 0.005;  % Hyperparameter of Optimization
parameters.gamma = 19;    % Hyperparameter of Optimization
parameters.nseg  = 20;    % Hyperparameter of NMF
parameters.ws    = 27;    % Hyperparameter of LSH-> window size: ws/2, ws/4
parameters.mcgThreshold = 0.21; % Hierarchy threshold of MCG (Multiscale Combinatorial Grouping, 2014)
parameters.mcgDir = fullfile(pwd, 'MCG-BSDS500-all-ucm'); % Path to MCG oversegmentation files
%% Initial Segmentation
parameters.methodOfSegmentation = 'MCG'; % Initial over-segmentation methods {'MCG', 'Piotr', 'Slic'}
%% Image Path
[ parameters.fileName, parameters.filePath ] = uigetfile({'*.jpg';'*.bmp';'*.jpeg';'*.png';'*.TIF';'*.*'},'File Selector', fullfile(pwd,'Images') );
image = imread(fullfile(parameters.filePath, parameters.fileName));
%% IS4
addpath(genpath(pwd));
main(image, parameters);