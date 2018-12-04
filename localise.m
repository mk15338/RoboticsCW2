function [robot] = localise()

    COM_CloseNXT all 
    h =COM_OpenNXT();
    COM_SetDefaultNXT(h); 

    BOT_RADIUS = 10;
    target = [11 55];
    map = [0,0; 66,0; 66,44; 44,44; 44,66; 110,66; 110,110; 0,110];
    map_route = [44,22; 22,22; 22,44; 22,66; 22,88; 44,88; 66,88; 88,88];
   [startIx, currentAng, targIx] = navigateToNearestNode([55 33], pi/2,target, map_route);

    
%      robot = BotSim(map);
%      robot.drawMap();   
%     map = reduce_map(BOT_RADIUS, map);
%     robot = BotSim(map);
%     robot.setBotPos([44,22]);
%     robot.drawMap();
%     
%     angle = pi;
%     
%     navigateToNearestNode(current_position, current_angle, map_route)  
     currentAng = navigateAlongRoute(startIx, targIx, currentAng, map_route);
     [moveToTarget, rotateToTarget] = moveToPoint (map_route(targIx,:), currentAng, target);
     rotate_robot(rotateToTarget);
     move_robot(moveToTarget);
 
   
 
    COM_CloseNXT(h)
    
    %[location, ang] = particle_filter(robot, map);
    
    
end