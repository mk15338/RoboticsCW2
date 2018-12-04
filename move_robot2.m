function limit = move_robot2(distance)
COM_CloseNXT all 
h =COM_OpenNXT();
COM_SetDefaultNXT(h); 
MOTOR_POWER = -30;
motorA = NXTMotor('A') ;
motorB = NXTMotor('B') ;

ROTATION_DISTANCE = 17; %distance in cm covered by one full motor rotation
limit = round(abs(distance) * 360 / ROTATION_DISTANCE);

lim_move = limit;
motorA.Power = sign(distance)*MOTOR_POWER;
motorA.TachoLimit =  lim_move;
motorA.SendToNXT()

motorB.Power = sign(distance)*MOTOR_POWER;
motorB.TachoLimit = lim_move;
motorB.SendToNXT()
COM_CloseNXT(h)
end