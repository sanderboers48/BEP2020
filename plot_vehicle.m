%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is used for ploting a vehicle
% input variables: xc, yc as the coordinate of the "center of mass" of the
%                  vehicle; theta as the angle of the vehicle's hand; L is
%                  the length of the hand;
% Output variable: h is the handle object of the plotted vehicle 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = plot_vehicle(xc,yc,theta,L)
xpolybase = [0     -1/3*L  -1/3*L  1/3*L  1/3*L;
            2/3*L 3/10*L   -0.3*L  -0.3*L 3/10*L];

% Clockwise rotation matrix
Rot = [cos(pi/2-theta) sin(pi/2-theta);-sin(pi/2-theta) cos(pi/2-theta)]; 

xpoly = zeros(2,5);

for ii = 1:5
    xpoly(:,ii) = Rot*xpolybase(:,ii)+[xc;yc];
end
h1 = patch(xpoly(1,:),xpoly(2,:),'r');
set(h1,'FaceColor','none','LineWidth',2)
h = h1;
