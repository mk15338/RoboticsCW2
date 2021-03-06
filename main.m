clear;
clc;

%% Initialize the NXT robot
COM_CloseNXT all 
h =COM_OpenNXT();
COM_SetDefaultNXT(h); 
NXT_PlayTone(440, 500)
OpenUltrasonic(SENSOR_4);
motorA = NXTMotor('A') ;
motorB = NXTMotor('B') ;

%% Global parameters
MOTOR_POWER = -30;
DISTANCE_TO_MOVE = 20;
ANG_TO_ROTATE = 120;
NUMBER_OF_SCANS = 4;
MOTOR_C_POWER = 20;

%% MOVE ROBOT 
%move_robot(DISTANCE_TO_MOVE);


%% ROTATE ROBOT
%rotate_robot(ANG_TO_ROTATE);


%% TAKE SENSOR READINGS
robot_scan(4)
% motorC = NXTMotor('C');
% motorC.TachoLimit =  round((360 / NUMBER_OF_SCANS));
% motorC.Power = MOTOR_C_POWER;
% pause(0.3)
% for i = 1 : NUMBER_OF_SCANS
%     dists(i) = GetUltrasonic(SENSOR_4)
%     motorC.SendToNXT();
%     motorC.WaitFor();
% end
% motorC.Power = -MOTOR_C_POWER;
% motorC.TachoLimit =  360;
% motorC.SendToNXT()

COM_CloseNXT(h)




