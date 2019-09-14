%% Show vehicles moving along its respective route

% Load the multiple Mobile Station (MS) Route Info and the Base Station (BS) location
loadVehRouteData;

% Number of vehicles under consideration
nVehicle=5;

% Link State Probability Model - Parameter Settings:
lambda_S = 0.001; pLosThresh=0.1;

% Load the vehicle's route from the corresponding columns in the data set
% NOTE: We assume that the vehicle does not move significantly along the z-axis
for iVeh=1:nVehicle
    if iVeh~=indexVehMinSamples
        VehPositions{iVeh}(nMinSampOfAllRoutes+1:end,:) = [];
    end
    VehicleRoute{iVeh} = VehPositions{iVeh}(:,[1 2]);
    
    % For all Distance Steps: Azimuth and Elevation angle as seen from MS
    DistanceVector{iVeh} = repmat(BaseStationPosition,...
        [nMinSampOfAllRoutes 1]) - VehPositions{iVeh};
    
    %%%% Link State Probabilities %%%%
    % First we compute the Tx Antenna-Rx Antenna Separation %
    % Base Station Height > Vehicle Antenna's Height %
    TxRxSep{iVeh}=sqrt(sum(DistanceVector{iVeh}.^2,2));
    P_LOS{iVeh} = (1-exp(-4*TxRxSep{iVeh}*lambda_S))./(4*TxRxSep{iVeh}*lambda_S);
    p_B{iVeh} = 1 - P_LOS{iVeh};
    linkState{iVeh}=(P_LOS{iVeh}>pLosThresh);
    
    % Azimuth Angle: IN DEGREE
    Theta{iVeh} = (180/pi)*atan2(DistanceVector{iVeh}(:,2),DistanceVector{iVeh}(:,1));
    % Elevation Angle: IN DEGREE
    Phi{iVeh} = (180/pi)*atan(DistanceVector{iVeh}(:,3)./...
        sqrt(sum(DistanceVector{iVeh}(:,[1 2]).^2,2)));
    
    ThetaBS{iVeh} = (180+Theta{iVeh}); ThetaMS{iVeh} = (Theta{iVeh});
    PhiBS{iVeh} = 90+Phi{iVeh}; PhiMS{iVeh} = -Phi{iVeh};
end

%% Plot the vehicle's movement along the route + beam alignment directions
figure('name','1','units','normalized','outerposition',[0 0 1 1])
%figure(1)

% %% Set up the movie.
% writerObj = VideoWriter('out.avi'); % Name it.
% writerObj.FrameRate = 60; % How many frames per second.
% open(writerObj);

for iNum=1:nMinSampOfAllRoutes
    clf;
    img = imread('CitySectionAerialView.png'); imagesc([50 1069],[-50 620],flipud(img));
    hold on
    for iVeh=1:nVehicle
        if linkState{iVeh}(iNum)~=0
            % Plot the beam pattern of the BS
            P = plotArc(((180+Theta{iVeh}(iNum))*(pi/180)),...
                ((180+(15+Theta{iVeh}(iNum)))*(pi/180)),BaseStationPosition(1),...
                BaseStationPosition(2),20);
            set(P,'edgecolor','k','linewidth',1)
            % Plot the vehicle's route
            plot(VehicleRoute{iVeh}(:,1),VehicleRoute{iVeh}(:,2),'-r','LineWidth',3)
            set(gca,'ydir','normal');
            % Plot the beam pattern of the MS
            P = plotArc((Theta{iVeh}(iNum)*(pi/180)),...
                ((15+Theta{iVeh}(iNum))*(pi/180)),VehicleRoute{iVeh}(iNum,1),...
                VehicleRoute{iVeh}(iNum,2),20);
            set(P,'edgecolor','k','linewidth',1)
            rectangle('Position',[VehicleRoute{iVeh}(iNum,1)-5 VehicleRoute{iVeh}(iNum,2)-5 10 10],...
                'FaceColor','y','EdgeColor','c','LineWidth',1)
            % Plot the LoS component: MS and BS beams perfectly aligned
            AX=plot([VehicleRoute{iVeh}(iNum,1) BaseStationPosition(1)], [VehicleRoute{iVeh}(iNum,2)...
                BaseStationPosition(2)],'-b','LineWidth',1);
            ax = ancestor(AX, 'axes');
            yrule = ax.YAxis;xrule = ax.XAxis;
            % Change properties of the ruler
            yrule.FontSize = 18; xrule.FontSize = 18;
            % Add title and axis labels
            title(['Time Elapsed = ',int2str(iNum),' seconds'],'FontSize',25,'FontName','Arial','FontWeight','bold')
            xlabel('X Coordinate (in m)','FontSize',23,'FontName','Arial','FontWeight','bold')
            ylabel('Y Coordinate (in m)','FontSize',23,'FontName','Arial','FontWeight','bold')
            % Add a legend
            h=legend('MS/BS Beam', 'Vehicle''s Route');
            set(h,'FontSize',20,'FontName','Arial','FontWeight','bold');
            axis tight
            % Simulate the movement by pausing continually
            pause(0.025)
            %             frame = getframe(gcf); % 'gcf' can handle if you zoom in to take a movie.
            %             writeVideo(writerObj, frame);
        end
    end
end

hold off
% close(writerObj);
