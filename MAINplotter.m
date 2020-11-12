%% plotterrr BEP2020
clear
clc
close all

makeGIF = true;

fs = 24;        % Font size in the figure
avgMs = 10;     % Average marker size
ms = 8;         % MakerSize
lw = 2;         % Linewidth 

L = 2;          % Length boat
n = 3;          % Number of boats

load simData.mat;

t = simData.Time;
xPos = simData.Data(:,[1,4,7]);
yPos = simData.Data(:,[2,5,8]);
theta = double(simData.Data(:,[3,6,9]));

%%
pausetime = 0.01;                    % Pause time
gifName = 'test.gif';    % File name for saved gif
iniName = 'test_init.gif';% File name for snapshot of ini. cond.

figure
hold on
xlim([-1.05-20,1+20])
ylim([-0.9-20,1.35+20])
set(gcf,'Color',[1 1 1],'Position',[4 32 1671 950])
set(gca,'DataAspectRatio',[1 1 1],'Box','on','FontSize',fs)
xlabel('x(m)')
ylabel('y(m)')
for ii=1:1:length(t)    % Go through time from 0 to tfinal
    display(ii);
    h = zeros(7,1);
    hh = zeros(1,n);
    kk = 1;
    plot(xPos(ii,1:n),yPos(ii,1:n),'k.','MarkerSize',ms,'HandleVisibility','off')
    
    for jj = 1:n
        hh(:,jj) = plot_vehicle(xPos(ii,jj), yPos(ii,jj), theta(ii,jj), 2);
    end
%     for i0 = 1:n-1
%         for j0 = i0+1:n
%             if Adj(i0,j0) == 1
%                 h(kk) = line([qhx(ii,i0) qhx(ii,j0)],...
%                             [qhy(ii,i0),qhy(ii,j0)],'LineWidth',lw);
%                 kk = kk+1;
%             end
%         end
%     end 
    % At time 0, draw initial configuration and creat initial gif
    if ii == 1
        h1 = plot(xPos(ii,1:n),yPos(ii,1:n),'bs','MarkerSize',ms+2);
        plot(0,0,'MarkerSize',ms+2);
        legend(h1,'initial position','Location','NorthEast')
        if makeGIF
            f = getframe(gcf);
            f = frame2im(f);
            [im,map] = rgb2ind(f,128);
            imwrite(im, map, gifName, 'GIF', 'WriteMode', 'overwrite',...
                   'DelayTime', 0, 'LoopCount', inf);
            imwrite(im, map, iniName, 'GIF', 'WriteMode',...
                    'overwrite', 'DelayTime', 0, 'LoopCount', inf);
        end
    elseif ii == length(t) % At time tfinal, draw final configuration
        h2 = plot(xPos(ii,1:n),yPos(ii,1:n),'bo','MarkerSize',ms+2);
        for jj = 1:n
            plot_vehicle(xPos(ii,jj),yPos(ii,jj),theta(ii,jj),L);
        end
%         for i0 = 1:n-1
%             for j0 = i0+1:n
%                 if Adj(i0,j0) == 1
%                     line([qhx(ii,i0) qhx(ii,j0)],...
%                          [qhy(ii,i0),qhy(ii,j0)],'LineWidth',lw);
%                 end
%             end
%         end
        legend([h1,h2],'initial position','final position',...
                        'Location','NorthEast')
        if makeGIF
            f = getframe(gcf); %#ok<*UNRCH>
            f = frame2im(f);            [im,map] = rgb2ind(f,128);
            imwrite(im,map,gifName,'gif','WriteMode','append',...
                   'DelayTime', 5)
        end 
        % in time between 0 and tfinal, make gif writemode to be append
        if makeGIF
            f = getframe(gcf);
            f = frame2im(f);
            legend(h1,'initial position','Location','NorthEast' ,'AutoUpdate','off')
            [im,map] = rgb2ind(f,128);
            imwrite(im,map,gifName,'gif','WriteMode','append',...
                   'DelayTime', 0)
        end
    end
    pause(pausetime) % Time pause between two trajectory dots
    delete(hh)
end

