clear all
%close all

%% 1. Define the access path to the required other packages.
% This are typically the sphericalHarmonics and  ScannerDesign packages.
disp('1. Define the access path to the required other packages.')
addpath(genpath('.'))
addpath(genpath('..\SphericalHarmonics\'))

%% 2. Loading the scanner model.
% It is made of at least the spherical harmonics coefficient, the radius in which they are define and the nominal current used for the coil.
disp('2. Loading the scanner''s coil codel')
%Data could be found in https://github.com/gBringout/ScannerDesign
load('FFL11_light.mat');
%load('IdealFFL11.mat');

%% defining the geometry of the Field of View
system.x = -0.010:0.001:0.010;
system.y = -0.011:0.001:0.010;
system.z = 0:0.001:0;

% we have a 2D field of view with a in-plane resolution of 1mm

%% Explenation of the Spherical harmonics coefficient structure

% the implemented formule is described in my thesis
% on page 8 eq 2.12 and following. 
% I am using the Schmidt quasi-normalisation, mainly to quickly
% get to the ideal field strength/ideal gradient strength. For example, when we take the
% coefficient c_{x11}^R = 2g, with the Schmidt quasi normalization, I can
% quickly see that I have a main gradient of 2g/R T/m. ! It is very
% usefull for me! Of course, the real gradient strength will be slightly
% different in the reality (and space dependant), as all the other
% coefficient play also a role. But this normalisation is grat for engineer

% So, for the selection coil (maxwell), stored in the Selection_Z
% structure, we have the coeficient from order 1 and grade 1 stored in
cx11 = Selection_Z.bc(1).coefficient(2,2); % due to the indexing not stating at zero in matlab, cxlm coeffieint are always stored in l+1 m+1 index
cy11 = Selection_Z.bs(2).coefficient(2,2); % not that negative order are stored in the "bs" structure, and not "bc"
cz11 = Selection_Z.bc(3).coefficient(2,1); 
%All of them defined on a sphere of 
R = Selection_Z.rhoReference;

% Which gives us an (approximated) ideal gradient efficiency of
cx11/R % T/m per Amp?re in the x direction
cy11/R % T/m per Amp?re in the y direction
cz11/R % T/m per Amp?re in the z direction

% I have to admit that it was unclear in my presentation(and perhaps
% wrongly explained) how the sensitivity and magnetic field are linked.
% So basicaly, for a coil (see my diss section 2.3.3.2, page 25)
% Spherical Harmonics Coefficient (SHC) = efficiency = sensitivity is equivalent to a "Magnetic field" for a
% current of 1 Ampere
% So, to make a magnetic field of 15 mT with a drive coil with a SHC cx00= 51 10^-6 T/Ampere
% I need a current of (15 10^-3)/(51 10^-6) = 294 Ampere.
% So the same coil, used as drive coil or receive coil, will have the same
% SHC. For the sensititvity (p_{jk} in your case) we will simply use the
% SHC coefficient stored in the matrix, as their are already saved for a
% unit current. To obtain the magnetic field, we will multiply the SHC by
% 294, to get our 15 mT Field.

cx00 = Drive_X.bc(1).coefficient(1,1);
p1 = Drive_X.bc(1).coefficient(1,1);
B1 = 294*Drive_X.bc(1).coefficient(1,1);
% When using the same coil as drive and receive, the same coeffiecient can
% be used to calculate both the magnetic field and the sensitivity profil.
% B = 294*cx00
% p = cx00

% So, to use back the table from my presentation (slide 21), it is completly unclear
% that c_{x11}^R = -a only described the shape of the field involved, but not their amplitude
% that should be, using the correcte amplitude, scale with a current. 
% This will lead to, using different curent I_j for the coil, to a relation:
% a*I_{Selection Maxwell} = g*I_{Quadrupole 0}

%% calculate the magnetic fields for a unitary current in the plan defined earlier

Selection_Z.B = RebuildField7(Selection_Z.bc,Selection_Z.bs,Selection_Z.rhoReference,system.x,system.y,system.z,'sch');
%display the field

figure
subplot(1,3,1)
imagesc(squeeze(Selection_Z.B(1,:,:)));
title('Sensitivity profil in x direction or Bx with a current of 1 Amp?re')
subplot(1,3,2)
imagesc(squeeze(Selection_Z.B(2,:,:)));
title('Sensitivity profil in y direction or By with a current of 1 Amp?re')
subplot(1,3,3)
imagesc(squeeze(Selection_Z.B(3,:,:)));
title('Sensitivity profil in z direction or Bz with a current of 1 Amp?re')

