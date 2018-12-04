function [moveCommand, turnCommand] = moveToPoint(currentPos,currentAng,target)
c1 = (target(1)-currentPos(1));
c2 =  (target(2)-currentPos(2));
tg = c2/c1;
ang = atan(tg);
if c1 == 0 && c2 == 0
    moveCommand = 0;
    turnCommand = 0;
    return
end

if c2 >= 0
    if c1 <= 0
        ang = pi - abs(ang);
    end
end
if c2 < 0
    if c1<0
        ang = pi + ang;

    end
end
turnCommand = (ang - currentAng);
moveCommand = sqrt((currentPos(1) - target(1))^2+(currentPos(2) - target(2))^2);
%turnCommand = 0;
end