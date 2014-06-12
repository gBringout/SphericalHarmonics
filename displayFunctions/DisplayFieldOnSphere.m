function [ ] = DisplayFieldOnSphere( B,rk,titleGraph )
%Display2DField Display the absolute value and the components of a field in a plane
%   Detailed explanation goes here
if nargin<3
    titleGraph = 'Empty Title';
end

Babs = squeeze(sqrt(B(1,:).^2+B(2,:).^2+B(3,:).^2));
%Babs = B(3,:);
%Bx = squeeze(B(1,:,:));
%By = squeeze(B(2,:,:));
%Bz = squeeze(B(3,:,:));


figure('Name',titleGraph)
%title(titleGraph)
scatter3(rk(:,1),rk(:,2),rk(:,3),100,Babs,'filled')
caxis([-max(Babs) max(Babs)])
xlabel('x axis')
ylabel('y axis')
zlabel('z axis')
% 
% subplot(2,3,2)
% imagesc(x,y,Babs');
% title(sprintf('Max= %e',max(max(Babs))))
% axis 'square';
% 
% subplot(2,3,4)
% imagesc(x,y,Bx');
% title(sprintf('Max= %e',max(max(Bx))))
% axis 'square';
% 
% subplot(2,3,5)
% imagesc(x,y,By');
% title(sprintf('Max= %e',max(max(By))))
% axis 'square';
% 
% subplot(2,3,6)
% imagesc(x,y,Bz');
% title(sprintf('Max= %e',max(max(Bz))))
% axis 'square';


end

