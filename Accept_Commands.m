function [cmd_seq] = Accept_Commands(serRoomba)

%function is started by pressing both buttons, one or both may still be
%held, so we need to wait until user depresses both buttons: buttonsAll
%goes to [0 0] when both next and play are depressed.
init=1;
while(init)
    pause(.1)
    [BumpSensors ButtonsAll whlDrop]=Check_Sensors(serRoomba);
    init=sum(ButtonsAll);
end

%initialize stop criteria
End_Command_Input = 0;

cmd_seq=[];

%start command entry mode loop
j=0;
fprintf('Start Command Entry Mode Loop \n');
% fprintf('Input Command \n');

%turn on Play light, Power set to green
SetLEDsRoomba(serRoomba,0,0,100);
while End_Command_Input==0;
    
    
    %loop through until an input is dectected
    [BumpSensors ButtonsAll whlDrop]=Check_Sensors(serRoomba);
    
    %check if only play or pause was hit, did the person mean to hit both
    %or just one of them. take a reading two tenths of a second later. If they
    %meant to hit both they will be holding them by now
    if(sum(ButtonsAll)==1)
        pause(.1)
        [BumpSensors ButtonsAll whlDrop]=Check_Sensors(serRoomba);
    end
    
    %process button press
    if sum(ButtonsAll)==2 && j>0
        %both play and next were pressed
        %exit command input mode
        fprintf('Leaving command input mode. \n');
        End_Command_Input = 1;
        
        %turn on Both Lights, set Power to Green, have Roomba Beep
        SetLEDsRoomba(serRoomba,0,100,100);
        BeepRoomba(serRoomba);
        pause(0.5);
        %reset LEDs to only power Green
        SetLEDsRoomba(serRoomba,1,0,100);
    elseif BumpSensors>0 || sum(ButtonsAll)>0
        %bump sensor or next or play was pressed
        %save the command...
        
        %fwd=1
        %left=2
        %right=3
        %Play=4
        %Next=5
        if(ButtonsAll(1)==1)
            BumpSensors=5;
        elseif(ButtonsAll(2)==1)
            BumpSensors=4;
        end
        fprintf('Saving command. %d \n',BumpSensors);
        cmd_seq(end+1)=BumpSensors;
        
        %Alert User what they pressed
        switch BumpSensors
            case 1, %Front
                %turn on Advance light, set Power to Red, have Roomba Beep once
                SetLEDsRoomba(serRoomba,3,100,100);
                BeepRoomba(serRoomba);
                pause(0.5);
                %turn back to Play light, Power to Green
                SetLEDsRoomba(serRoomba,0,0,100);
            case 2, %Left
                %turn on Advance light, set Power to Red, have Roomba Beep once
                SetLEDsRoomba(serRoomba,1,100,100);
                BeepRoomba(serRoomba);
                pause(0.5);
                %turn back to Play light, Power to Green
                SetLEDsRoomba(serRoomba,0,0,100);
            case 3, %Right
                %turn on Advance light, set Power to Red, have Roomba Beep once
                SetLEDsRoomba(serRoomba,2,100,100);
                BeepRoomba(serRoomba);
                pause(0.5);
                %turn back to Play light, Power to Green
                SetLEDsRoomba(serRoomba,0,0,100);
            case 4, %Arc Left
                SetLEDsRoomba(serRoomba,1,100,100);
                BeepRoomba(serRoomba);
                pause(.15)
                SetLEDsRoomba(serRoomba,0,100,100);
                pause(.15)
                SetLEDsRoomba(serRoomba,1,100,100);
                pause(.2)
                SetLEDsRoomba(serRoomba,0,0,100);
            case 5, %Arc Right
                SetLEDsRoomba(serRoomba,2,100,100);
                BeepRoomba(serRoomba);
                pause(.15)
                SetLEDsRoomba(serRoomba,0,100,100);
                pause(.15)
                SetLEDsRoomba(serRoomba,2,100,100);
                pause(.2)
                SetLEDsRoomba(serRoomba,0,0,100);
        end
        
        
        j=j+1;
%         fprintf('Input Command \n');
    elseif whlDrop>0
        %delete the last command
        cmd_seq=cmd_seq(1:end-1);
        
        %set Power to Red, have Roomba Beep Once
        SetLEDsRoomba(serRoomba,0,100,100);
        BeepRoomba(serRoomba);
        pause(0.5);
        %turn back to Play light, Power to Green
        SetLEDsRoomba(serRoomba,0,0,100);
        
        %wait to leave this state until the robot is back on the ground
        %with all wheel sensors on ground
        while(whlDrop>0)
            [BumpSensors ButtonsAll whlDrop]=Check_Sensors(serRoomba);
            pause(.2)
        end
    end
end