function [] = displaySHC(bc,bs,type,scaling)
% We have 2 type of graphs. The pyramide or the bar

if nargin<3
    type = 1; % This is the pyramid
    scaling = 10^-3;
end
if nargin <4
    scaling = 10^-3;
end
    

if type ==1
%% Try to build a represnetation of the SHC as:
    %bs22 bs21 bc20 bc21 bc22
    %   0 bs11 bc10 bc11    0
    %   0    0 bc00    0    0

    nMax = size(bc(1,1).coefficient,1)-1;
    bx = zeros(nMax+1,2*nMax+1);
    by = zeros(nMax+1,2*nMax+1);
    bz = zeros(nMax+1,2*nMax+1);


    for n=0:nMax
        for m=-n:n
            if m<0
                bx(nMax-n+1,m+nMax+1) = bs(1,1).coefficient(n+1,-m+1);
                by(nMax-n+1,m+nMax+1) = bs(1,2).coefficient(n+1,-m+1);
                bz(nMax-n+1,m+nMax+1) = bs(1,3).coefficient(n+1,-m+1);
            else
                bx(nMax-n+1,m+nMax+1) = bc(1,1).coefficient(n+1,m+1);
                by(nMax-n+1,m+nMax+1) = bc(1,2).coefficient(n+1,m+1);
                bz(nMax-n+1,m+nMax+1) = bc(1,3).coefficient(n+1,m+1);
            end
        end
    end

    % Overlyed 2D bars
    %set(0,'DefaultAxesColorOrder',[1 0 0;0 1 0;0 0 1]) %or whatever you want
    graphColor = jet(nMax+1);
    %graphColor = ['r';'g';'b';'c';'m';'y';'k';[255 127 80]];
    K = 0.8;
    yMax1 = max([max(max(abs(bx))),max(max(abs(by))),max(max(abs(bz)))]);
    yMax = ceil(yMax1/(10^floor(log10(yMax1))))*(10^floor(log10(yMax1)));

    figure('Name','Spherical harmonics values')
    subplot(1,3,1)
    legendText='';
    for n=0:nMax
        barHandle = bar(-nMax:nMax, scaling*abs(bx(nMax-n+1,:)));
        set(gca,'YScale','log')
        set(barHandle,'BarWidth',(nMax-n+1)*(1/(nMax+1))*K, 'FaceColor', graphColor(n+1,:), 'EdgeColor', graphColor(n+1,:));
        if n<10
            legendText = [legendText;sprintf('0%ith degree',n)];
        else
            legendText = [legendText;sprintf('%ith degree',n)];
        end
        hold all;
    end
    title('B_x coefficient')

    subplot(1,3,2)
    for n=0:nMax
        barHandle = bar(-nMax:nMax, scaling*abs(by(nMax-n+1,:))); 
        set(gca,'YScale','log')
        set(barHandle,'BarWidth',(nMax-n+1)*(1/(nMax+1))*K, 'FaceColor', graphColor(n+1,:), 'EdgeColor', graphColor(n+1,:));
        hold all;
    end
    title('B_y coefficient')

    subplot(1,3,3)
    for n=0:nMax
        barHandle = bar(-nMax:nMax, scaling*abs(bz(nMax-n+1,:))); 
        set(gca,'YScale','log')
        set(barHandle,'BarWidth',(nMax-n+1)*(1/(nMax+1))*K, 'FaceColor', graphColor(n+1,:), 'EdgeColor', graphColor(n+1,:));
        hold all;
    end
    title('B_z coefficient')


    axesHandles = get(gcf, 'children');
    for i=1:size(axesHandles,1)
        xlabel(axesHandles(i),'mth order');
        ylabel(axesHandles(i),'abs(Maximum amplitude) \\10^{-3} T.A^{-1}');
        set(axesHandles(i),'XGrid','on','Xlim',[-(nMax+1) (nMax+1)],'Ylim',[10^-4 10^2])
        legend(legendText,'Location','SouthEast')

        %xlim([-(nMax+1) (yMax+1)])
    end
elseif type == 2
    %% Try to build a represnetation of the SHC as:
    % bc00 bs11 bc10 bc11 bs22 bs21 bc20 bc21 bc22
    % with a ligne at  1 mT
    
    nMax = size(bc(1,1).coefficient,1)-1;
    bx = zeros(nMax+1,2*nMax+1);
    by = zeros(nMax+1,2*nMax+1);
    bz = zeros(nMax+1,2*nMax+1);
    
    graphColor = jet(nMax+1);

    point = 0;
    for n=0:nMax
        for m=-n:n
            point = point +1;
            colorBar(point,:) = graphColor(n+1,:);
            if m<0
                bx(point) = bs(1,1).coefficient(n+1,-m+1);
                by(point) = bs(1,2).coefficient(n+1,-m+1);
                bz(point) = bs(1,3).coefficient(n+1,-m+1);
            else
                bx(point) = bc(1,1).coefficient(n+1,m+1);
                by(point) = bc(1,2).coefficient(n+1,m+1);
                bz(point) = bc(1,3).coefficient(n+1,m+1);
            end
            x(point) = m;
        end
    end
    
    
    figure('Name','Spherical harmonics values')
    legendText='';
    
    subplot(3,1,1)
    point = 0;
    for n=0:nMax
        for m=-n:n
            point = point+1;
            barHandle = bar(point,scaling*abs(bx(point)));
            hold all
            
            if bx(point)>0
                set(barHandle,'FaceColor', colorBar(point,:), 'EdgeColor', colorBar(point,:));
            else
                set(barHandle,'FaceColor', 0.25*colorBar(point,:), 'EdgeColor', colorBar(point,:));
                set(barHandle,'LineWidth',2);
            end
            %applyhatch_pluscolor(barHandle, '\-x.', 'rkbk');
        end
    end
    set(gca,'YScale','log')
    title('B_x coefficient')

    subplot(3,1,2)
    point = 0;
    for n=0:nMax
        for m=-n:n
            point = point+1;
            barHandle = bar(point,scaling*abs(by(point)));
            hold all
            
            if by(point)>0
                set(barHandle,'FaceColor', colorBar(point,:), 'EdgeColor', colorBar(point,:));
            else
                set(barHandle,'FaceColor', 0.25*colorBar(point,:), 'EdgeColor', colorBar(point,:));
                set(barHandle,'LineWidth',2);
            end
        end
    end
    set(gca,'YScale','log')
    title('B_y coefficient')

    subplot(3,1,3)
    point = 0;
    for n=0:nMax
        for m=-n:n
            point = point+1;
            barHandle = bar(point,scaling*abs(bz(point)));
            hold all
            
            if bz(point)>0
                set(barHandle,'FaceColor', colorBar(point,:), 'EdgeColor', colorBar(point,:));
            else
                set(barHandle,'FaceColor', 0.25*colorBar(point,:), 'EdgeColor', colorBar(point,:));
                set(barHandle,'LineWidth',2);
            end
        end
    end
    set(gca,'YScale','log')
    title('B_z coefficient')


    axesHandles = get(gcf, 'children');
    for i=1:3%size(axesHandles,1)
        xlabel(axesHandles(i),'mth order');
        ylabel(axesHandles(i),sprintf('abs(Maximum amplitude) / 10^{%i} T.A^{-1}',-log10(scaling)));
        set(axesHandles(i),'Ylim',[10^-2 10^2],'XTick',1:75,'XTickLabel',x);
        xlim([0 50])
        
        %legend(legendText,'Location','SouthEast')
        %xlim([-(nMax+1) (yMax+1)])
    end
end
    
