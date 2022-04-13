%% Robot Location Check
function [N, G, Sl, So] = Biome(Robot,Dims)
N  = false;
G  = false;
Sl = false;
So = false;

if Robot.X < Dims(1)
    N  = true;
elseif Robot.X < Dims(1) + Dims(2)
    G  = true;
elseif Robot.X < Dims(1) + Dims(2) + Dims(3)
    Sl = true;
else
    So = true;
end
end
