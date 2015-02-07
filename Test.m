%% Ideal field + Gaus & Rectangle
clear all
close all

addpath(genpath(fullfile('.')))

degreeMax = 7;
orderMax = degreeMax; % We try to get all the order for each degree
rhoReference = 1;

rk = createTargetPointGaussLegendreAndRectangle7(rhoReference,degreeMax,orderMax);

bc(1).coefficient = zeros(degreeMax,orderMax);
bc(2).coefficient = zeros(degreeMax,orderMax);
bc(3).coefficient = zeros(degreeMax,orderMax);
bs(1).coefficient = zeros(degreeMax,orderMax);
bs(2).coefficient = zeros(degreeMax,orderMax);
bs(3).coefficient = zeros(degreeMax,orderMax);

bc(1).coefficient(1,1) = 0.78;
bc(1).coefficient(2,2) = 1;
bc(1).coefficient(3,1) = 2;
bc(1).coefficient(5,1) = 3;
bc(1).coefficient(7,1) = 4;

B  = RebuildField7bis(bc,bs,rhoReference,rk,'sch');
displayFieldOnSphere(B,rk,'Test')

[bc2,bs2] = getSphericalHarmonicsCoefficientMeasure7(B(1,:,:),B(2,:,:),B(3,:,:),degreeMax,orderMax,rk,'sch');
disp(sprintf('%g\n',bc2(1).coefficient(1,1)))
disp(sprintf('%g\n',bc2(1).coefficient(2,2)))
disp(sprintf('%g\n',bc2(1).coefficient(3,1)))
disp(sprintf('%g\n',bc2(1).coefficient(5,1)))
disp(sprintf('%g\n Done\n',bc2(1).coefficient(7,1)))
displaySHC(bc2,bs2,2,1)

% in a 2D plan
x = -rhoReference:rhoReference/50:rhoReference;
y = -rhoReference:rhoReference/50:rhoReference;
z= 0;
B  = RebuildField7(bc,bs,rhoReference,x,y,z,'sch');
Bx = squeeze(B(1,:,:));
figure;imagesc(x,y,Bx);