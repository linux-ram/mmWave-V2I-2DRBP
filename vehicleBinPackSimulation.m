% Load the multiple Mobile Station (MS) Route Info and the Base Station (BS) location
loadVehRouteData;

% Link State Probabilities
lambda_S = 0.001; pLosThresh=0.5;

% Number of trials & number of vehicles 
numtrials=5; nVehicle = [1 2 5 10 50]; 
WS={}; trialMean={};

%% MRU: Minimum Resource Unit
DeltaT = 0.16e-6; DeltaB = 25e3;
MRU = [DeltaT DeltaB];

%% RB at the BS
Ttot = 1; Btot = 1e9;
% 2D Bin
RB = round([Ttot Btot]./MRU);
KnapsackArea = prod(RB);

% %delete saved .mat file
% File = fullfile(cd, 'plotVar.mat');
% delete(File);
% disp(exist(File, 'file'))

for j=1:numtrials
    
    for expt=1:size(nVehicle,2)
        Results=[];
        % %% Set up the movie.
        % writerObj = VideoWriter('out.avi'); % Name it.
        % writerObj.FrameRate = 60; % How many frames per second.
        % open(writerObj);
        
        % Load the vehicle's route from the corresponding columns in the data set
        % NOTE: We assume that the vehicle does not move significantly along the z-axis
        for iVeh=1:nVehicle(expt)
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
            
            %% RSB at MS
            [T, B] = generateRSB(nVehicle,expt,Ttot,Btot,nMinSampOfAllRoutes);
            VehRSB{iVeh} = round([T B]./MRU);
        end
        
        for iNum=1:nMinSampOfAllRoutes
            clf; RSB=[];
            %% Plot the vehicle's movement along the route + beam alignment directions
            %figure('name','1','units','normalized','outerposition',[0 0 1 1])
            figure(1)
            img = imread('CitySectionAerialView.png'); imagesc([50 1069],[-50 620],flipud(img));
            hold on
            for iVeh=1:nVehicle(expt)
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
                    RSB=[RSB; VehRSB{iVeh}(iNum,:)];
                    % Cleanup NaNs and Inf
                    RSB(isnan(RSB)) = 1; RSB(isinf(RSB)) = 1;
                end
                if iVeh == nVehicle(expt) && size(RSB,1)>=1
                    %Determine Packing
                    [data, NRsbLeftUnpacked, IndRsbLeftUnpacked, TrimLoss] = determinePacking(RB, RSB);
                    Results=[Results;TrimLoss];
                    % Visualize the output
                    %figure('name','2','units','normalized','outerposition',[0 0 1 1])
                    figure(2)
                    visualizePacking(RB, data, NRsbLeftUnpacked, IndRsbLeftUnpacked, TrimLoss)
                    % Simulate the movement by pausing continually
                    pause(0.5)
                    %             frame = getframe(gcf); % 'gcf' can handle if you zoom in to take a movie.
                    %             writeVideo(writerObj, frame);
                end
            end
        end
        WS(expt)={Results};
    end
    
    hold off
    % close(writerObj);
    
    trialMean(j,:)={cellfun(@mean, WS, 'UniformOutput', false)}; %columnwise mean value;
    save('plotVar.mat', 'nVehicle', 'trialMean', 'j', 'numtrials');
end

figure(3)
AllTrim=cell2mat(cellfun(@(x) cell2mat(x),trialMean,'un',0));
MeanUtil=mean(AllTrim);
Sigma=std(AllTrim);
errorbar(nVehicle,MeanUtil,Sigma,'r','LineWidth',2)
hold on
Finale=stem(nVehicle,MeanUtil,'ks','LineWidth',2,'MarkerSize',10);
title('Mean Time-Frequency Resource Utilization','FontSize',25,'FontName','Arial','FontWeight','bold')
xlabel('Vehicle Density (Vehicles per Km)','FontSize',23,'FontName','Arial','FontWeight','bold')
ylabel('Trim Loss','FontSize',23,'FontName','Arial','FontWeight','bold')
set(gca,'XTick',nVehicle)
set(gca, 'XScale', 'log', 'LineWidth', 1.3)
xlim([0.9 60])
final = ancestor(Finale, 'axes');
yrule = final.YAxis;xrule = final.XAxis;
% Change properties of the ruler
yrule.FontSize = 18; xrule.FontSize = 18;
yrule.FontWeight = 'bold'; xrule.FontWeight = 'bold';
grid on
