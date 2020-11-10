%% plotterrr BEP2020
clear
clc
close all

makeGIF = false;

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

%% Plot trajectory
figure
hold on
xlim([-1.05-20,1+20])
ylim([-0.9-20,1.35+20])
set(gca,'DataAspectRatio',[1 1 1],'Box','on','FontSize',fs)
for ii=1:1:length(t)
    for jj = 1:n
        plot(xPos(ii,jj),yPos(ii,jj),'k.','MarkerSize',avgMs)
        if ii == 1
           h1 = plot(xPos(ii,jj),yPos(ii,jj),'rs','MarkerSize',1.4*avgMs,...
                     'LineWidth',lw);
        end
        if ii == length(t)
           h2 = plot(xPos(ii,jj),yPos(ii,jj),'ro','MarkerSize',1.4*avgMs,...
                     'LineWidth',lw);
        end
    end
    if (ii==1)||(ii==length(t))
        for jj = 1:n
            h = plot_vehicle(xPos(ii,jj),yPos(ii,jj),theta(ii,jj),L);
        end
%         for i0 = 1:n-1
%             for j0 = i0+1:n
%                 if Adj(i0,j0) == 1 && (ii==length(t))
%                    line([qhx(ii,i0) qhx(ii,j0)],[qhy(ii,i0),qhy(ii,j0)],...
%                     'LineWidth',lw)
%                 end
%             end
%         end
    end
    pause(0.05) % Uncomment this if animation is needed
end
legend([h1,h2],'Initial position','Final position','Location','NorthEast')
xlabel('x (m)')
ylabel('y (m)')
%% Plot distance error %%
nn = 1:8:length(t); % Plot distance error (e) and velocity tracking error 
                    % (s) using less points
figure
subplot(211)
hold on
set(gca,'Box','on','FontSize',fs)
plot(t(nn),e12(nn),'-+','LineWidth',lw,'MarkerSize',1.2*avgMs,...
     'Color',[0 0 1]);
plot(t(nn),e23(nn),'-o','LineWidth',lw,'MarkerSize',0.8*avgMs,...
     'Color',[0 0.5 0]);
plot(t(nn),e34(nn),'-*','LineWidth',lw,'MarkerSize',1.2*avgMs,...
     'Color',[1 0 0]);
plot(t(nn),e45(nn),'.-','LineWidth',lw,'MarkerSize',2.0*avgMs,...
     'Color',[0 0 0]);
plot(t(nn),e15(nn),'-x','LineWidth',lw,'MarkerSize',1.4*avgMs,...
     'Color',[0.75 0 0.75]);
xlabel('Time (s)')
ylabel('${e}_{ij}\mbox{ (m)}$','Interpreter','latex')
h1 = legend('${e}_{12}$','${e}_{23}$','${e}_{34}$',...
        '${e}_{45}$','${e}_{15}$','Location','SouthEast');
set(h1,'Interpreter','latex')
xlim([0 10])
ylim([-0.4 0.1])
subplot(212)
hold on
set(gca,'Box','on','FontSize',fs)
plot(t(nn),e13(nn),'-+','LineWidth',lw,'MarkerSize',1.2*avgMs,...
     'Color',[0 0 1]);
plot(t(nn),e14(nn),'-o','LineWidth',lw,'MarkerSize',0.8*avgMs,...
     'Color',[0 0.5 0]);
plot(t(nn),e24(nn),'-*','LineWidth',lw,'MarkerSize',1.2*avgMs,...
     'Color',[1 0 0]);
plot(t(nn),e25(nn),'.-','LineWidth',lw,'MarkerSize',2.0*avgMs,...
     'Color',[0 0 0]);
plot(t(nn),e35(nn),'-x','LineWidth',lw,'MarkerSize',1.4*avgMs,...
     'Color',[0.75 0 0.75]);
xlabel('Time (s)')
ylabel('${e}_{ij}\mbox{ (m)}$','Interpreter','latex')
h2 = legend('${e}_{13}$','${e}_{14}$','${e}_{24}$',...
        '${e}_{25}$','${e}_{35}$','Location','SouthEast');
set(h2,'Interpreter','latex')
xlim([0 10])
ylim([-0.6 0.15])


%% Plot the actual control input %%
figure
subplot(211)
hold on
set(gca,'Box','on','FontSize',fs)
plot(t(nn),ubar(1,nn),'LineWidth',1);
plot(t(nn),ubar(3,nn),'LineWidth',1);
plot(t(nn),ubar(5,nn),'LineWidth',1);
plot(t(nn),ubar(7,nn),'LineWidth',1);
plot(t(nn),ubar(9,nn),'LineWidth',1);
xlim([0 10])
ylim([-2.5 2])
xlabel('Time (s)')
ylabel('$\bar{u}_{ix}\mbox{ (N)}$','Interpreter','latex')
grid

subplot(212)
hold on
set(gca,'Box','on','FontSize',fs)
plot(t(nn),ubar(2,nn),'LineWidth',1);
plot(t(nn),ubar(4,nn),'LineWidth',1);
plot(t(nn),ubar(6,nn),'LineWidth',1);
plot(t(nn),ubar(8,nn),'LineWidth',1);
plot(t(nn),ubar(10,nn),'LineWidth',1);
xlim([0 10])
ylim([-0.35 0.35])
xlabel('Time (s)')
ylabel('$\bar{u}_{iy}\mbox{ (N-m)}$','Interpreter','latex')
grid

%% Plot error of estimation dynamics
for ii = 1:n
    figure(ii+4)
    hold on
    set(gca,'Box','on','FontSize',fs)
    plot(t(nn),phihat(nn,6*ii-5),'-+','LineWidth',lw,...
        'MarkerSize',1.2*avgMs,'Color',[0 0 1]);
    plot(t(nn),phihat(nn,6*ii-4),'-o','LineWidth',lw,...
        'MarkerSize',0.8*avgMs,'Color',[0 0.5 0]);
    plot(t(nn),phihat(nn,6*ii-3),'-*','LineWidth',lw,...
        'MarkerSize',1.2*avgMs,'Color',[1 0 0]);
    plot(t(nn),phihat(nn,6*ii-2),'.-','LineWidth',lw,...
        'MarkerSize',2*avgMs,'Color',[0 0 0]);
    plot(t(nn),phihat(nn,6*ii-1),'-x','LineWidth',lw,...
        'MarkerSize',1.4*avgMs,'Color',[0.75 0 0.75]);
    plot(t(nn),phihat(nn,6*ii),'--','LineWidth',lw,'Color',[0 0 0]);
    xlabel('Time (s)')
    ylabel(['$\hat{\phi}_{',num2str(ii),'}$'],'Interpreter','latex')
    h = legend(['$[\hat{\phi}_{',num2str(ii),'}]_{1}$'],...
               ['$[\hat{\phi}_{',num2str(ii),'}]_{2}$'],...
               ['$[\hat{\phi}_{',num2str(ii),'}]_{3}$'],...
               ['$[\hat{\phi}_{',num2str(ii),'}]_{4}$'],...
               ['$[\hat{\phi}_{',num2str(ii),'}]_{5}$'],...
               ['$[\hat{\phi}_{',num2str(ii),'}]_{6}$'],...
               'Location','NorthEast');
    set(h,'Interpreter','latex')
end

% Plot errors again
figure
plot(t(nn),e12(nn),t(nn),e23(nn),t(nn),e34(nn),t(nn),e45(nn),...
     t(nn),e15(nn),t(nn),e13(nn),t(nn),e14(nn),t(nn),e24(nn),...
     t(nn),e25(nn),t(nn),e35(nn),'LineWidth',1);
xlabel('Time')
ylabel('e_i_j')
grid