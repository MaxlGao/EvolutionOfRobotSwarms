%% Robot Mover
% no collisions for now
function [X, Y] = MoveBot(Robot,Speed,theta,Dims)
X = Robot.X + Speed*cos(theta);
Y = Robot.Y + Speed*sin(theta);
if X < 0
    X = 0;
elseif X > sum(Dims(1:4))
    X = sum(Dims(1:4));
end
if Y < 0
    Y = 0;
elseif Y > Dims(5)
    Y = Dims(5);
end
end