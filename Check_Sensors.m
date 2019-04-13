function [BumpSensors ButtonsAll whlDrop] = Check_Sensors(serRoomba)

[BumpRight,BumpLeft,WheDropRight,WheDropLeft,WheDropCaster,BumpFront]= BumpsWheelDropsSensorsRoomba(serRoomba);
BumpSensors = BumpFront+2*BumpLeft+3*BumpRight;
% disp([BumpRight BumpLeft BumpFront])
% disp([BumpRight BumpLeft BumpFront WheDropRight,WheDropLeft,WheDropCaster])
whlDrop=any([WheDropRight,WheDropLeft,WheDropCaster]);
[ButtonAdv,ButtonPlay] = ButtonsSensorRoomba(serRoomba);
ButtonsAll = [ButtonAdv ButtonPlay];
% disp(ButtonsAll)
end