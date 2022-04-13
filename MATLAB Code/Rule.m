%% Robot Rulesets
function [Behavior, Want_Food, Drop_Food] = Rule(Robot) 
% Defaults
Behavior = Robot.Behavior;
Want_Food = Robot.Condition.Want_Food;
Drop_Food = Robot.Condition.Drop_Food;

% Rule 1: Go to source if you aren't busy
if Robot.Job == "Generalist" || Robot.Job == "Dropper"
    if Robot.Condition.Stay_Down == false &&...
       Robot.Condition.Has_Food  == false &&...
       Robot.Condition.On_Source == false
        % rule ignores existing robot behavior
        Behavior = "Go_To_Source";
    end
end

% Rule 2: Get off the slope if you aren't supposed to be there.
if Robot.Job == "Collector"
    if Robot.Condition.Stay_Down == true &&...
       Robot.Condition.On_Slope  == true
        % rule ignores existing robot behavior
        Behavior = "Go_To_Nest";
    end
end

% Rule 3: Look for food if not busy (Collector)
if Robot.Job == "Collector"
    if Robot.Condition.Stay_Down == true &&...
       Robot.Condition.Has_Food  == false &&...
       Robot.Condition.On_Grass  == true
        if Robot.Behavior == "Go_To_Nest"
            if rand < 0.10
                Behavior = "Random_Walk";
            end
            Want_Food = true;
        end
    end
end

% Rule 4: Look for food if not busy (Dropper + Generalist)
if Robot.Job == "Generalist" || Robot.Job == "Dropper"
    if Robot.Condition.On_Source == true &&...
       Robot.Condition.Has_Food  == false
        if Robot.Behavior == "Go_To_Source"
            if rand < 0.10
                Behavior = "Random_Walk";
            end
            Want_Food = true;
        end
    end
end

% Rule 5: Stop looking for food if you have some, and go to the nest
% Rule ignores job
    if Robot.Condition.Has_Food  == true
        if Robot.Behavior == "Go_To_Source" || ...
           Robot.Behavior == "Random_Walk" 
            Behavior = "Go_To_Nest";
            Want_Food = false;
        end
    end


% Rule 6: Drop the food if you are at the slope
if Robot.Job == "Dropper"
    if Robot.Condition.On_Slope  == true &&...
       Robot.Condition.Has_Food  == true &&...
       Robot.Condition.Stay_Up   == true
        % Rule ignores behavior
            Behavior = "Go_To_Source";
            Drop_Food = true;
        
    end
end

% Rule 7: Drop the food if you are at the nest, and look for more.
if Robot.Job == "Collector" || Robot.Job == "Generalist"
    if Robot.Condition.On_Nest   == true &&...
       Robot.Condition.Has_Food  == true
        if Robot.Behavior == "Random_Walk" || ...
           Robot.Behavior == "Go_To_Nest"
            Behavior = "Random_Walk";
            Drop_Food = true;
            Want_Food = true;
        end
    end
end

% Rule 8: Start looking for food if you're at the nest
if Robot.Job == "Collector" || Robot.Job == "Generalist"
    if Robot.Condition.On_Nest   == true &&...
       Robot.Condition.Has_Food  == false
        if Robot.Behavior == "Random_Walk" || ...
           Robot.Behavior == "Go_To_Nest"
            Behavior = "Go_To_Source";
        end
    end
end
end