%% MATLAB code for MAT 495 Project by Max Gao
%% constants and miscellany
clear
clf

% Basic settings
Period   = 5000;
N_Items  = 5; % N items always in the source.
N_Robots = 4;

% Speed Settings: Going up the slope is much slower than going down.
%         Nominal, Up Slope, Down Slope, V_Item
Rates  = [   0.15,    0.015,       0.23,      1];
%         L_Base, L_Flat, L_Sloped, L_Source, Width
Dims   = [     1,    3.5,        4,        1,  1.75];
% origin is x = 0. Base goes from x=0 to x=1 etc.

% Zeros and Ones
time        = 1;
Cache_Size  = zeros(1,Period);
theta       = 0;
Speed       = 0;
Target      = 0;
Carrying    = zeros(1,N_Robots);
XData       = zeros(N_Robots,Period);
YData       = zeros(N_Robots,Period);
XY_Items    = zeros(2,N_Items); 
Transported = 0;

for i = 1:N_Items
    XY_Items(1,i) = rand*(Dims(4)) + sum(Dims(1:3));
    XY_Items(2,i) = rand*Dims(5);
end
%% Robot Initialization
for i = 1:N_Robots
    % Placement
    Robot(i).X = 0;
    Robot(i).Y = i*Dims(5)/(N_Robots+1);
    % Robot Conditions Initialization
    Robot(i).Condition.Stay_Down = false;
    Robot(i).Condition.Has_Food  = false;
    Robot(i).Condition.On_Source = false;
    Robot(i).Condition.On_Slope  = false;
    Robot(i).Condition.On_Grass  = false;% grass=flat area
    Robot(i).Condition.Stay_Up   = false;
    Robot(i).Condition.On_Nest   = true;
    Robot(i).Condition.Want_Food = false;% not officially a condition. 
    Robot(i).Condition.Drop_Food = false;% not officially a condition.
    Robot(i).Job = "Generalist";
    % Robot Behaviors Initialization
    % robots can only have one of three behaviors, the other two being
    % "Go_To_Source" and "Go_To_Nest"
    Robot(i).Behavior = "Random_Walk";

end
% Robot Job Initialization
for i = 1:N_Robots/2
    Robot(i).Job = "Collector";
    Robot(i).Condition.Stay_Down = true;
end
for i = (N_Robots/2+1):N_Robots
    Robot(i).Job = "Dropper";
    Robot(i).Condition.Stay_Up = true;
end
%% Main Loop
%hold on
%rectangle('Position',[0,0,sum(Dims(1:4)),2])
while time <= Period
    hold off
    clf
    rectangle('Position',[0                      ,0,Dims(1),Dims(5)])
    hold on
    rectangle('Position',[Dims(1)                ,0,Dims(2),Dims(5)])
    rectangle('Position',[Dims(1)+Dims(2)        ,0,Dims(3),Dims(5)])
    rectangle('Position',[Dims(1)+Dims(2)+Dims(3),0,Dims(4),Dims(5)])
    axis([-3 12 -.25 2])
    for i=1:N_Robots
        % Call Biome
        [Robot(i).Condition.On_Nest,...
         Robot(i).Condition.On_Grass,...
         Robot(i).Condition.On_Slope,...
         Robot(i).Condition.On_Source] = Biome(Robot(i),Dims);
        % Call Path
        [theta, Speed] = Path(Robot(i),Robot(i).Condition.On_Slope,Rates);
        % Call Rule
        [Robot(i).Behavior,...
         Robot(i).Condition.Want_Food,...
         Robot(i).Condition.Drop_Food] = Rule(Robot(i));
        % Call Pickup
        [Target, picked] = Pickup(Robot(i),XY_Items,Carrying,Dims);
        if picked
            Robot(i).Condition.Has_Food = true;
            Carrying(i) = Target; % Carrying(5) = 4 means that robot 5 is carrying item number 4.
            if Robot(i).Condition.On_Source
                XY_Items = [XY_Items [rand*(Dims(4)) + sum(Dims(1:3));rand*Width]];
            end
        end
        if Carrying(i) ~= 0
            XY_Items(:,Carrying(i)) = [Robot(i).X, Robot(i).Y];
        end
        % Call Dropoff
        if Robot(i).Condition.Drop_Food
            [Item, Returned] = Dropoff(Robot(i),Carrying(i));
            if Returned
                Transported = Transported + 1;
                XY_Items(:,Carrying(i)) = [-2,2-0.03*Transported];
                Carrying(i) = 0;
            end
            if Item ~=0
                Robot(i).Condition.Drop_Food = false;
                Robot(i).Condition.Has_Food = false;
                Carrying(i) = 0;
            end
        end
        % Call MoveBot
        [Robot(i).X,Robot(i).Y] = MoveBot(Robot(i),Speed,theta,Dims);
        XData(i,time) = Robot(i).X;
        YData(i,time) = Robot(i).Y;
        % Plot
        plot(Robot(i).X,Robot(i).Y,'ob','MarkerSize',5)
    end

    % Drop Items
    for i = 1:length(XY_Items)
        if XY_Items(1,i) > (sum(Dims(1:2)) - rand - 1) &&... % stops 1-2 m from the ramp
           XY_Items(1,i) < sum(Dims(1:3)) &&...
           all(Carrying ~= i)
            XY_Items(1,i) = XY_Items(1,i) - V_Item;
        end
    end
    plot(XY_Items(1,:),XY_Items(2,:),'xr','MarkerSize',10)
    txt = ['Number Transported: ', num2str(Transported)];
    text(4,1.9,txt)
    txt = ['Time: ', num2str(time)];
    text(4,1.83,txt)
     txt = ['Carrying: ', num2str(Carrying)];
     text(6,1.9,txt)
    %pause(0.1)
    %if time>=150 % uncomment this if statement to skip the first part
        drawnow % uncomment this to view the animation.
    %end
    time = time + 1;
end
plot(XData',YData')
