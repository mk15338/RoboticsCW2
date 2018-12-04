function [botSim] = localise(botSim,map,target)
%This function returns botSim, and accepts, botSim, a map and a target.
%LOCALISE Template localisation function

    
    target = [80 80];
    map=[0,0;60,0;60,45;45,45;45,59;106,59;106,105;0,105]; %DELETE LATER!!!
    botSim = BotSim(map);
    botSim.drawMap();
    botSim.randomPose(0);
    botSim.setBotPos([20 20]);
    botSim.setBotAng(0);

    BOT_RADIUS = 5;
    map = reduce_map(BOT_RADIUS, map);
    
    [location, ang] = particle_filter(botSim, map);
    %ang = botSim.getBotAng();
    %location = botSim.getBotPos();
    %[route] = a_star(botSim, location, map, target);
    
    %{
    botSim.drawBot(5);
    moveToPoint(ang, location, [20 30], botSim);
    
    
    for c = length(route):-1: 1
        [location, ang] = move_to_point(ang, location, [route(c,1) route(c,2)], botSim);
        botSim.drawBot(0);
    end
    
    botSim.drawBot(5);

    %}
  
end
