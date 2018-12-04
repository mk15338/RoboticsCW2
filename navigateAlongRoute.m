function final_ang = navigateAlongRoute(startIndex, endIndex, angle, map_route)
    if(startIndex < endIndex)
         for i = startIndex: endIndex - 1  
               [moveCommand, turnCommand] = moveToPoint(map_route(i,:), angle ,map_route(i+1,:));
               rotate_robot(turnCommand);
               move_robot(moveCommand);
               angle = angle + turnCommand;
         end
    elseif(endIndex < startIndex)
        for i = startIndex: -1: endIndex + 1  
               [moveCommand, turnCommand] = moveToPoint(map_route(i,:), angle ,map_route(i-1,:));
               rotate_robot(turnCommand)
               move_robot(moveCommand);
               angle = angle + turnCommand;
        end
    end
    final_ang = angle;
end