function [rk] = createTargetPointGaussLegendreAndRectangle7(radius,degreeMax,orderMax)

% P(1,1) = x coordinate
% P(1,2) = y coordinate
% P(1,3) = z coordinate
% P(1,4) = r coordinate
% P(1,5) = phi coordinate
% P(1,6) = theta coordinate

nbrPointsPhi = orderMax*2+1;
nbrPointsTheta = degreeMax+1;

[gaussLegendreAbscissas , useless] = gauss(nbrPointsTheta);
% Phi - Alex recommand to use the left rectangle technic, to match
% with his code
startPhi = 0;
stopPhi = 2*pi;
stepPhi = (stopPhi-startPhi)/nbrPointsPhi;
AbsissasPhi = startPhi:stepPhi:stopPhi-stepPhi;
% theta - with Gaussian coefficient
%a = aTheta;
%b = bTheta;
%AbsissasTheta = ((b-a)/2)*gaussLegendreAbscissas + (a+b)/2;
% Do the the variable change, we have to change the abscissas
AbsissasTheta = acos(gaussLegendreAbscissas);

point=1;
for i=1:size(AbsissasPhi,2) %phi
    for j=1:size(AbsissasTheta,1) %theta
        rk(point,4) = radius;% radius
        rk(point,5) = AbsissasPhi(i);% phi
        rk(point,6) = AbsissasTheta(j);% theta
        
        rk(point,1) = rk(point,4)*sin(rk(point,6))*cos(rk(point,5)); %x
        rk(point,2) = rk(point,4)*sin(rk(point,6))*sin(rk(point,5)); %y
        rk(point,3) = rk(point,4)*cos(rk(point,6)); %z
        point = point+1;
    end
end