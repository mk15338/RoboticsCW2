COM_CloseNXT all 
h =COM_OpenNXT();
COM_SetDefaultNXT(h); 
NXT_PlayTone(440, 500)
COM_CloseNXT(h)

motorA = NXTMotor('A') ;
motorA.power = 50;
motorA.SendToNXT()
