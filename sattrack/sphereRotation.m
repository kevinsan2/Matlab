clearvars;close all force;clc;
figure(1)
% Rotate a graphics object 180º about the x-axis.
[x,y,z] = sphere;
image_file = 'http://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Land_ocean_ice_2048.jpg/1024px-Land_ocean_ice_2048.jpg';
alpha = 1;
h = surf(x,y,z);
%% Rotate a surface graphics object 45º about its center in the z direction.
figure(2)
cdata = imread(image_file);

% Set image as color data (cdata) property, and set face color to indicate
% a texturemap, which Matlab expects to be in cdata. Turn off the mesh edges.

set(globe, 'FaceColor', 'texturemap', 'CData', cdata,...
    'FaceAlpha', alpha, 'EdgeColor', 'none');
zdir = [0 0 1];
center = [0,0,0];
rotate(globe,zdir,45,center)