function lim = rotate_robot(ang)
% 4*174 = one full rotation
    ROTATION_DISTANCE = 4*174;
    lim = round(ang*ROTATION_DISTANCE/360);
end
