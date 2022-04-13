%% Robot Trajectory Generator
function [theta,Speed] = Path(Robot,Sloped,Rates)
% theta = 0 is towards the source
if Robot.Behavior == "Random_Walk"
    theta = rand*2*pi;
elseif Robot.Behavior == "Go_To_Nest"
    theta = pi;
else
    theta = 0;
end
if Sloped && theta == pi
    Speed = Rates(3);
elseif Sloped && theta == 0
    Speed = Rates(2);
else
    Speed = Rates(1);
end
end