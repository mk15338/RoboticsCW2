function [startIx, angR, targIx] = navigateToNearestNode(pos, ang, target, map)
    minStartD = intmax;
    minTargD = intmax;
    nearestStartIx = 1;
    nearestTargIx = 1;
    
    for i = 1:length(map)

        testStartX = (pos(1) - map(i,1))^2;
        testStartY = (pos(2) - map(i,2))^2;
        testTargX = (target(1) - map(i,1))^2;
        testTargY = (target(2) - map(i,2))^2;

        testStart = testStartX + testStartY;
        testTarg = testTargX + testTargY;
        if minStartD > testStart
            minStartD = testStart;
            nearestStartIx = i;
        end
        if minTargD > testTarg
            minTargD = testTarg;
            nearestTargIx = i;
        end
        

    end
    
    nearestStartNode = map(nearestStartIx,:);
    [moveC, turnC] = moveToPoint(pos, ang, nearestStartNode);
    angR = ang + turnC;
    startIx = nearestStartIx;
    rotate_robot(turnC);
    move_robot(moveC);
    
    targIx = nearestTargIx;


end