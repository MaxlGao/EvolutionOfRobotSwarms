%% Item Pickup
function [Item,Pickup] = Pickup(Robot,XYItems,Carrying,Dims)
% a robot can only pick up a single item at a time.
Item = 0;
X1 = Robot.X;
Y1 = Robot.Y;
X2 = XYItems(1,:);
Y2 = XYItems(2,:);
Dist = sqrt((X1-X2).^2 + (Y1-Y2).^2);
for i=1:length(XYItems)
    if Dist(i) < 0.20 && all(Carrying ~= i)
        % picks up the oldest item if there happen to be more than one.
        % but the item must not be carried by another robot.
        Item = i;
    end
end
% The robot found an item. The robot may pick it up as long as its not in
% the nest area. The robot must also want to pick it up.
% If the robot is a Dropper, it must refrain from picking up on the ramp.
if Robot.Condition.Want_Food && ~Robot.Condition.On_Nest && Item ~= 0
    Pickup = true;
    if Robot.Job == "Dropper" && X2(Item) < sum(Dims(1:3))
        Pickup = false;
    end
else
    Pickup = false;
end
end