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
DISTANCE_TO_MOVE = 140;
ANG_TO_ROTATE = 120;

%% MOVE ROBOT 
% lim_move = move_robot(DISTANCE_TO_MOVE);
% motorA.Power = sign(DISTANCE_TO_MOVE)*MOTOR_POWER;
% motorA.TachoLimit =  lim_move;
% motorA.SendToNXT()

% motorB.Power = sign(DISTANCE_TO_MOVE)*MOTOR_POWER;
% motorB.TachoLimit = lim_move;
% motorB.SendToNXT()


%% ROTATE ROBOT
% lim_rot = rotate_robot(ANG_TO_ROTATE);
% motorA.Power = sign(ANG_TO_ROTATE)*MOTOR_POWER;
% motorA.TachoLimit =  lim_rot;
% motorA.SendToNXT()
% 
% motorB.Power = -sign(ANG_TO_ROTATE)*MOTOR_POWER;
% motorB.TachoLimit = lim_rot;
% motorB.SendToNXT()

%% Some sensor shit
for i = 1 : 10
dists = GetUltrasonic(SENSOR_4); % Returns a distance in CM
dists
pause(1);
end
COM_CloseNXT(h)




