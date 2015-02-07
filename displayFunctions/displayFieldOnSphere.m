function [ ] = displayFieldOnSphere( B,rk,titleGraph )
%display2DField Display the absolute value and the components of a field in a plane
%   Detailed explanation goes here
if nargin<3
    titleGraph = 'Empty Title';
end

Babs = squeeze(sqrt(B(1,:).^2+B(2,:).^2+B(3,:).^2));
%Babs = B(3,:);
Bx = squeeze(B(1,:,:));
By = squeeze(B(2,:,:));
Bz = squeeze(B(3,:,:));


figure('Name',titleGraph)
%title(titleGraph)
scatter3(rk(:,1),rk(:,2),rk(:,3),100,Babs,'filled')
caxis([-max(Babs) max(Babs)])
xlabel('x axis')
ylabel('y axis')
zlabel('z axis')
axis 'square';

figure
subplot(2,3,2)
scatter3(rk(:,1),rk(:,2),rk(:,3),100,Babs','filled')
title(sprintf('Max= %e',max(max(Babs))))
xlabel('x axis')
ylabel('y axis')
zlabel('z axis')
axis 'square';

subplot(2,3,4)
scatter3(rk(:,1),rk(:,2),rk(:,3),100,Bx','filled')
title(sprintf('Max= %e',max(max(Bx))))
xlabel('x axis')
ylabel('y axis')
zlabel('z axis')
axis 'square';

subplot(2,3,5)
scatter3(rk(:,1),rk(:,2),rk(:,3),100,By','filled')
title(sprintf('Max= %e',max(max(By))))
xlabel('x axis')
ylabel('y axis')
zlabel('z axis')
axis 'square';

subplot(2,3,6)
scatter3(rk(:,1),rk(:,2),rk(:,3),100,Bz','filled')
title(sprintf('Max= %e',max(max(Bz))))
xlabel('x axis')
ylabel('y axis')
zlabel('z axis')
axis 'square';


end

