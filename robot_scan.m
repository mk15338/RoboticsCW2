function dists = robot_scan(NUMBER_OF_SCANS)

    MOTOR_POWER = 20;
    motorC = NXTMotor('C');
    
    motorC.TachoLimit =  round((360 / NUMBER_OF_SCANS));
    motorC.Power = MOTOR_POWER;
    pause(0.3)
    for i = 1 : NUMBER_OF_SCANS
        dists(i) = GetUltrasonic(SENSOR_4);
        if(i ~= NUMBER_OF_SCANS)
            motorC.SendToNXT();
            motorC.WaitFor();
        end
    end
    motorC.Power = -MOTOR_POWER;
    motorC.TachoLimit =  (360/NUMBER_OF_SCANS) * (NUMBER_OF_SCANS - 1);
    motorC.SendToNXT()
    motorC.WaitFor();

end