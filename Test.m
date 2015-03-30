%% This files provides an example for the use of spherical harmonics

clear all
close all

addpath(genpath(fullfile('.')))

%% we set first at which maximum degree and order we want to make the model
% and run the approximation
degreeMax = 7;
orderMax = degreeMax; % We calculate the same number of order as degree.You do not have to
rhoReference = 1; % set the reference radius to 1 meter

% the point used for the description of the sphere are created. Note that
% they are specificaly choosen in order to make the numerical intergal
% more precise
rk = createTargetPointGaussLegendreAndRectangle7(rhoReference,degreeMax,orderMax);

figure
plot3(rk(:,1),rk(:,2),rk(:,3),'*');
axis equal

%% the bc and bs coefficietn are inizialized for each field direction
bc(1).coefficient = zeros(degreeMax+1,orderMax+1);
bc(2).coefficient = zeros(degreeMax+1,orderMax+1);
bc(3).coefficient = zeros(degreeMax+1,orderMax+1);
bs(1).coefficient = zeros(degreeMax+1,orderMax+1);
bs(2).coefficient = zeros(degreeMax+1,orderMax+1);
bs(3).coefficient = zeros(degreeMax+1,orderMax+1);

% we decide to try with a field topology as:
% this is arbitrary
bc(1).coefficient(1,1) = -0.78;
bs(1).coefficient(2,2) = 1;
bc(1).coefficient(3,1) = 2;
bc(2).coefficient(5,1) = pi;
bc(3).coefficient(7,1) = 4;

%% we calculate the value of the modeled field on the point of a sphere
B  = RebuildField7bis(bc,bs,rhoReference,rk,'sch');
displayFieldOnSphere(B,rk,'Field calculated from our topology')


%% Then we approximate the previously calculated field as a spherical harmonics expansion
% we should get exactly the same number, as we are making back an expansion
% with the correctorder
[bc2,bs2] = getSphericalHarmonicsCoefficientMeasure7(B(1,:,:),B(2,:,:),B(3,:,:),degreeMax,orderMax,rk,'sch');
disp(sprintf('%g',bc2(1).coefficient(1,1)))
disp(sprintf('%g',bs2(1).coefficient(2,2)))
disp(sprintf('%g',bc2(1).coefficient(3,1)))
disp(sprintf('%g',bc2(2).coefficient(5,1)))
disp(sprintf('%g \n Done\n',bc2(3).coefficient(7,1)))

% we can then display them
displaySHC(bc2,bs2,2,1)

% and reconstruct the Bx field ampltiude in a 2D plan
x = -rhoReference:rhoReference/50:rhoReference;
y = -rhoReference:rhoReference/50:rhoReference;
z= 0;
B  = RebuildField7(bc,bs,rhoReference,x,y,z,'sch');
Bx = squeeze(B(1,:,:));
figure
imagesc(x,y,Bx);
axis image
title('x component of the magentic field')