function lim = rotate_robot(ang)
    % 4*174 = one full rotation
    COM_CloseNXT all 
    h =COM_OpenNXT();
    COM_SetDefaultNXT(h); 
    MOTOR_POWER = -30;
    motorA = NXTMotor('A') ;
    motorB = NXTMotor('B') ;


    ROTATION_DISTANCE = 4*174;
    lim = round(ang*ROTATION_DISTANCE/360);
    
    lim_rot=lim;
    
    motorA.Power = sign(ang)*MOTOR_POWER;
    motorA.TachoLimit =  lim_rot;
    motorA.SendToNXT()

    motorB.Power = -sign(ang)*MOTOR_POWER;
    motorB.TachoLimit = lim_rot;
    motorB.SendToNXT()
end
