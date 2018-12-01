function limit = move_robot(distance)
ROTATION_DISTANCE = 17; %distance in cm covered by one full motor rotation
limit = round(abs(distance) * 360 / ROTATION_DISTANCE);
end