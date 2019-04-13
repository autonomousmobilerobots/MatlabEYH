function [BumpSensors ButtonsAll] = Detect_Commands(serRoomba)

%initialize bump sensors vector and buttons vector
BumpSensors = 0;
ButtonsAll = zeros(1,2);

i=0;
%loop through until an input is dectected
while BumpSensors==0 && i<50 && sum(ButtonsAll)~=1
%     fprintf(['This is the ' num2str(i+1) ' time through the input dectection loop \n']);
    [BumpRight,BumpLeft,WheDropRight,WheDropLeft,WheDropCaster,BumpFront]= BumpsWheelDropsSensorsRoomba(serRoomba);
%     BumpSensors = [BumpRight BumpLeft BumpFront];
    BumpSensors = BumpFront+2*BumpLeft+3*BumpRight;
    [ButtonAdv,ButtonPlay] = ButtonsSensorRoomba(serRoomba);
    ButtonsAll = [ButtonAdv ButtonPlay];
    i=i+1;
end

end