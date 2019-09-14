clear all; clc; close all;

% Load 10 vehicular routes from the .mat file
load vehicularRoutes.mat

% Load Base Station (BS) location. You can also reset it manually here.
BaseStationPosition = BS_pos;

%% Use the 10 Routes to create as many number of routes as required
VehPositions{1} = flipud(path1(:,[2 3 4]));
VehPositions{2} = path2(:,[2 3 4]);
VehPositions{3} = flipud(path3(:,[2 3 4]));
VehPositions{4} = flipud(path4(:,[2 3 4]));
VehPositions{5} = path5(:,[2 3 4]);
VehPositions{6} = flipud(path6(:,[2 3 4]));
VehPositions{7} = flipud(path7(:,[2 3 4]));
VehPositions{8} = path8(:,[2 3 4]);
VehPositions{9} = path9(:,[2 3 4]);
VehPositions{10} = flipud(path10(:,[2 3 4]));
VehPositions{11} = path1(:,[2 3 4]);
VehPositions{12} = flipud(path2(:,[2 3 4]));
VehPositions{13} = path3(:,[2 3 4]);
VehPositions{14} = path4(:,[2 3 4]);
VehPositions{15} = flipud(path5(:,[2 3 4]));
VehPositions{16} = path6(:,[2 3 4]);
VehPositions{17} = path7(:,[2 3 4]);
VehPositions{18} = flipud(path8(:,[2 3 4]));
VehPositions{19} = flipud(path9(:,[2 3 4]));
VehPositions{20} = path10(:,[2 3 4]);
VehPositions{21} = path1(:,[2 3 4])+[5 5 0];
VehPositions{22} = flipud(path2(:,[2 3 4]))+[5 5 0];
VehPositions{23} = path3(:,[2 3 4])+[5 5 0];
VehPositions{24} = path4(:,[2 3 4])+[5 5 0];
VehPositions{25} = flipud(path5(:,[2 3 4]))+[5 5 0];
VehPositions{26} = path6(:,[2 3 4])+[5 5 0];
VehPositions{27} = path7(:,[2 3 4])+[5 5 0];
VehPositions{28} = flipud(path8(:,[2 3 4]))+[5 5 0];
VehPositions{29} = flipud(path9(:,[2 3 4]))+[5 5 0];
VehPositions{30} = flipud(path10(:,[2 3 4]))+[5 5 0];
VehPositions{31} = flipud(path1(:,[2 3 4]))+[5 5 0];
VehPositions{32} = path2(:,[2 3 4])+[5 5 0];
VehPositions{33} = flipud(path3(:,[2 3 4]))+[5 5 0];
VehPositions{34} = flipud(path4(:,[2 3 4]))+[5 5 0];
VehPositions{35} = path5(:,[2 3 4])+[5 5 0];
VehPositions{36} = flipud(path6(:,[2 3 4]))+[5 5 0];
VehPositions{37} = flipud(path7(:,[2 3 4]))+[5 5 0];
VehPositions{38} = path8(:,[2 3 4])+[5 5 0];
VehPositions{39} = path9(:,[2 3 4])+[5 5 0];
VehPositions{40} = path10(:,[2 3 4])+[5 5 0];
VehPositions{41} = flipud(path1(:,[2 3 4]))-[5 5 0];
VehPositions{42} = path2(:,[2 3 4])-[5 5 0];
VehPositions{43} = flipud(path3(:,[2 3 4]))-[5 5 0];
VehPositions{44} = flipud(path4(:,[2 3 4]))-[5 5 0];
VehPositions{45} = path5(:,[2 3 4])-[5 5 0];
VehPositions{46} = flipud(path6(:,[2 3 4]))-[5 5 0];
VehPositions{47} = flipud(path7(:,[2 3 4]))-[5 5 0];
VehPositions{48} = path8(:,[2 3 4])-[5 5 0];
VehPositions{49} = path9(:,[2 3 4])-[5 5 0];
VehPositions{50} = path10(:,[2 3 4])-[5 5 0];

% Find the index of the vehicle which has the minimum number of samples in its route
[nMinSampOfAllRoutes,indexVehMinSamples] = min([size(VehPositions{1},1),...
    size(VehPositions{2},1),size(VehPositions{3},1),...
    size(VehPositions{4},1),size(VehPositions{5},1),...
    size(VehPositions{6},1),size(VehPositions{7},1),...
    size(VehPositions{8},1),size(VehPositions{9},1),...
    size(VehPositions{10},1)]);

% Clear all variables except the ones required for simulation
clearvars -except BaseStationPosition VehPositions nMinSampOfAllRoutes indexVehMinSamples