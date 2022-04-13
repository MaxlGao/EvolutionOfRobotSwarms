%% Item Drop
function [Item, Returned] = Dropoff(Robot, Carrying)
Item = 0;
Returned = false;
% if the robot is at the nest, remove the item carried and send it on its
% way. Drop_Food needs to be manually turned off.
if Robot.Condition.On_Nest
    Item = Carrying;
    Returned = true;
elseif Robot.Condition.On_Slope
    Item = Carrying;
end
end