% visualize the eigenfunctions
clear all;clc;
addpath('../modelbuilder/'); 

fmesh  = '/jia/PNM/CONST/trueG/CONST3k/';
fout   = '/jia/PNM/CONST/output/trueG/CONST3k/';
fbase  = 'CONST_1L_3k.1';
fdtail = '0.0000000E+00_1.000000';

pOrder = 1; nproc = 8; nth = 6; 
Radial = 6.371E3;

fmeshorg = [fmesh,fbase];
fdat =  [fout,fbase,'_pod',int2str(pOrder),...
    '_np',int2str(nproc),'_',fdtail,'_',int2str(nth),'.dat'];

fvtk = [fout,fbase,'_pod',int2str(pOrder),...
    '_np',int2str(nproc),'_',fdtail,'_',int2str(nth),'.vtk'];

fvlist = [fout,fbase,'_pod',int2str(pOrder),...
    '_np',int2str(nproc),'_vlist.dat'];

[pxyz,tet,~,~,~] = read_mesh3d(fmeshorg);

fid = fopen(fvlist,'r'); 
vlist = fread(fid,'int'); 
fclose(fid);

fid = fopen(fdat,'r');
vsol = fread(fid,'float64');
fclose(fid);
eigm0 = reshape(vsol,3,length(vsol)/3);
eigm1(:,vlist) = eigm0;
eigm  = eigm1';

filename = fvtk;
data_title = 'eigenmodes';
% organize data
% .type field must be 'scalar' or 'vector'
% number of vector components must equal dimension of the mesh
data_struct(1).type = 'vector';
data_struct(1).name = 'modes';
data_struct(1).data = eigm1(:);

flipped = false;

stat = vtk_write_tetrahedral_grid_and_data(filename,data_title,pxyz/Radial,...
    tet,data_struct,flipped);
