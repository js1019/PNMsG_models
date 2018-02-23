% build up an earth model
clear all; clc;
 
fmesh = '/local/js116/NM_models/Earth/models/PREM1M/prem_7L_1M';
tetgen = '/home/js116/Documents/tetgen1.5.0/tetgen';
scaling = 6.371*10^3;
tic
% load radial information
load ../deal_prem/prem7L_noocean.mat

% radius 
R1 = RD(1,1); R2 = RD(2,1); R3 = RD(3,1);
R4 = RD(4,1); R5 = RD(5,1); R6 = RD(6,1);
R7 = RD(7,1);

% load unit spheres
load ../unitspheres/data/Sph42k.mat
p1 = R1*p;
np1 = size(p1,1); t1 = t; nt1 = size(t1,1);

load ../unitspheres/data/Sph42k.mat
p2 = p*R2; 
np2 = size(p2,1); t2 = t + np1; nt2 = size(t2,1);

load ../unitspheres/data/Sph42k.mat
p3 = p*R3; 
np3 = size(p3,1); t3 = t + np1 + np2;  nt3 = size(t3,1);

load ../unitspheres/data/Sph42k.mat
p4 = p*R4; 
np4 = size(p4,1); t4 = t + np1 + np2 +np3; nt4 = size(t4,1);

load ../unitspheres/data/Sph15k.mat
p5 = p*R5; 
np5 = size(p5,1); t5 = t + np1 + np2 +np3 + np4; 
nt5 = size(t5,1);

load ../unitspheres/data/Sph15k.mat
p6 = p*R6; 
np6 = size(p6,1); t6 = t + np1 + np2 +np3 + np4 + np5; 
nt6 = size(t6,1);

load ../unitspheres/data/Sph6k.mat
p7 = p*R7; 
np7 = size(p7,1); t7 = t + np1 + np2 +np3 + np4 + np5 + np6; 
nt7 = size(t7,1);

istart = 1; iend = np1; 
pin(istart:iend,:) = p1;
istart = iend + 1; iend = iend + np2; 
pin(istart:iend,:) = p2;
istart = iend + 1; iend = iend + np3; 
pin(istart:iend,:) = p3;
istart = iend + 1; iend = iend + np4; 
pin(istart:iend,:) = p4;
istart = iend + 1; iend = iend + np5; 
pin(istart:iend,:) = p5;
istart = iend + 1; iend = iend + np6; 
pin(istart:iend,:) = p6;
istart = iend + 1; iend = iend + np7; 
pin(istart:iend,:) = p7;


istart = 1; iend = nt1; 
tin(istart:iend,:) = t1;
istart = iend + 1; iend = iend + nt2; 
tin(istart:iend,:) = t2;
istart = iend + 1; iend = iend + nt3; 
tin(istart:iend,:) = t3;
istart = iend + 1; iend = iend + nt4; 
tin(istart:iend,:) = t4;
istart = iend + 1; iend = iend + nt5; 
tin(istart:iend,:) = t5;
istart = iend + 1; iend = iend + nt6; 
tin(istart:iend,:) = t6;
istart = iend + 1; iend = iend + nt7; 
tin(istart:iend,:) = t7;

% generate internal surfaces 
trisurf2poly(fmesh,pin,tin);
toc
% generate the mesh
%a = 4e10; % 3k6 20k
%a = 8e8; % 15k 100k
a = 3e6; % 42k 1M

unix([tetgen,' -pq1.5nYVFAa',num2str(a,'%f'),' ',fmesh,'.poly']);
toc
[pout,tout,~,at] = read_mesh3d([fmesh,'.1']);
toc
vtk_write_general([fmesh,'_face.vtk'],'test',pin,tin);
toc