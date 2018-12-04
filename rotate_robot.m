function lim_rot = rotate_robot(ang)
    
    if ang ~= 0
        

        if (ang < -pi)
            ang = ang + 2 * pi
        end
        % 4*174 = one full rotation
        COM_CloseNXT all 
        h =COM_OpenNXT();
        COM_SetDefaultNXT(h); 
        MOTOR_POWER = -30;
        motorA = NXTMotor('A') ;
        motorB = NXTMotor('B') ;


        ROTATION_DISTANCE = 4*174;
        lim_rot = abs(round(ang*ROTATION_DISTANCE/(2*pi)));
        motorA.Power = sign(ang)*MOTOR_POWER;
        motorA.TachoLimit =  lim_rot;
        motorA.SendToNXT()

        motorB.Power = -sign(ang)*MOTOR_POWER;
        motorB.TachoLimit = lim_rot;
        motorB.SendToNXT();

        motorA.WaitFor();
        motorB.WaitFor();
    else
        lim_rot = 0;
    end
end
