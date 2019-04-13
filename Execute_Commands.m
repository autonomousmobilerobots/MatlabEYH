function [] = Execute_Commands(serRoomba,cmd_seq)
disp('Execute Mode')

%function is started by pressing both buttons, one or both may still be
%held, so we need to wait until user depresses both buttons: buttonsAll
%goes to [0 0] when both next and play are depressed.
init=1;
while(init)
    pause(.1)
    [BumpSensors ButtonsAll whlDrop]=Check_Sensors(serRoomba);
    init=sum(ButtonsAll);
end

%start the timer
tic;
i=1;
%check the sensors first
ButtonsAll=[0 0];

%wait to execute until play button has been pressed
while(ButtonsAll(2)==0)
    [BumpSensors ButtonsAll] = Check_Sensors(serRoomba);
    if(sum(ButtonsAll)==2)
        return;
    end
end
SetLEDsRoomba(serRoomba,1,100,100);
BeepRoomba(serRoomba);
pause(.5)
SetLEDsRoomba(serRoomba,1,0,100);

run_execute=1;
while(run_execute)
    %start the loop which stops on an input
    BumpSensors=0;ButtonsAll=[0 0];
    fprintf('Executing program, starting at step %d\n',i)
    %reset the current mode of the robot
    In_Command_Flag=0;
    while(sum(BumpSensors)==0 && sum(ButtonsAll)==0 && whlDrop==0 && i<=length(cmd_seq))
        switch cmd_seq(i)
            case 1 %forward 0.5 m
                %if we are just starting a command
                if In_Command_Flag == 0
                    %start the timer clock
                    tstart = toc;
                    %start the command
    %                 SetFwdVelRadiusRoomba(serRoomba, 0.1, inf);
                    % traction_offset*in2mm*in/mm2m;
                    SetFwdVelAngVelCreate(serRoomba,.92*2.54*12/100,0);
                    %set the flag
                    In_Command_Flag = 1;
                %if we have finished the command
                elseif In_Command_Flag == 1 && toc-tstart >= 1
                    %stop the Roomba
    %                 SetFwdVelRadiusRoomba(serRoomba, 0, inf);
                    SetFwdVelAngVelCreate(serRoomba,0,0);
                    %reset the flag
                    In_Command_Flag = 0;
                    %increment the command
                    i=i+1;
                end
            case 2 %CCW turn in place
                %if we are just starting a command
                if In_Command_Flag == 0
                    %start the timer clock
                    tstart = toc;
                    %start the command
    %                 SetFwdVelRadiusRoomba(serRoomba, 0.1, eps);
                    SetFwdVelAngVelCreate(serRoomba,0,pi/4);
                    %set the flag
                    In_Command_Flag = 1;
                %if we have finished the command
                elseif In_Command_Flag == 1 && toc-tstart >= 1
                    %stop the Roomba
    %                 SetFwdVelRadiusRoomba(serRoomba, 0, inf);
                    SetFwdVelAngVelCreate(serRoomba,0,0);
                    %reset the flag
                    In_Command_Flag = 0;
                    %increment the command
                    i=i+1;
                end 
            case 3 %CW turn in place
                %if we are just starting a command
                if In_Command_Flag == 0
                    %start the timer clock
                    tstart = toc;
                    %start the command
    %                 SetFwdVelRadiusRoomba(serRoomba, 0.1, -eps);
                    SetFwdVelAngVelCreate(serRoomba,0,-pi/4);
                    %set the flag
                    In_Command_Flag = 1;
                %if we have finished the command
                elseif In_Command_Flag == 1 && toc-tstart >= 1
                    %stop the Roomba
    %                 SetFwdVelRadiusRoomba(serRoomba, 0, inf);
                    SetFwdVelAngVelCreate(serRoomba,0,0);
                    %reset the flag
                    In_Command_Flag = 0;
                    %increment the command
                    i=i+1;
                end  
            case 4 %CW turn in place
                %if we are just starting a command
                if In_Command_Flag == 0
                    %start the timer clock
                    tstart = toc;
                    %start the command
    %                 SetFwdVelRadiusRoomba(serRoomba, 0.1, -eps);
                    SetFwdVelAngVelCreate(serRoomba,.92*2.54*12/100,pi/4);
                    %set the flag
                    In_Command_Flag = 1;
                %if we have finished the command
                elseif In_Command_Flag == 1 && toc-tstart >= 1
                    %stop the Roomba
    %                 SetFwdVelRadiusRoomba(serRoomba, 0, inf);
                    SetFwdVelAngVelCreate(serRoomba,0,0);
                    %reset the flag
                    In_Command_Flag = 0;
                    %increment the command
                    i=i+1;
                end  
            case 5 %CW turn in place
                %if we are just starting a command
                if In_Command_Flag == 0
                    %start the timer clock
                    tstart = toc;
                    %start the command
    %                 SetFwdVelRadiusRoomba(serRoomba, 0.1, -eps);
                    SetFwdVelAngVelCreate(serRoomba,.92*2.54*12/100,-pi/4);
                    %set the flag
                    In_Command_Flag = 1;
                %if we have finished the command
                elseif In_Command_Flag == 1 && toc-tstart >= 1
                    %stop the Roomba
    %                 SetFwdVelRadiusRoomba(serRoomba, 0, inf);
                    SetFwdVelAngVelCreate(serRoomba,0,0);
                    %reset the flag
                    In_Command_Flag = 0;
                    %increment the command
                    i=i+1;
                end  
            otherwise
                fprintf('Invalid Command \n');
                %flash all lights on, power to red, beep, then flash to none and power green
                SetLEDsRoomba(serRoomba,3,100,100);
                %BeepRoomba(serRoomba);
                pause(0.2);
                SetLEDsRoomba(serRoomba,0,0,100);
                pause(0.2);
                %repeat
                SetLEDsRoomba(serRoomba,3,100,100);
                %BeepRoomba(serRoomba);
                pause(0.2);
                SetLEDsRoomba(serRoomba,1,0,100);
                %increment the command
                i=i+1;
        end
        [BumpSensors ButtonsAll whlDrop] = Check_Sensors(serRoomba);
    end
    %if we hit a bump sensor STOP the robot.
    SetFwdVelAngVelCreate(serRoomba,0,0);
    if(i<=length(cmd_seq))
        %beep only if robot was stopped by button or bump
        if(ButtonsAll(2)==1)
            SetLEDsRoomba(serRoomba,1,100,100);
        else
            SetLEDsRoomba(serRoomba,3,100,100);
        end
        BeepRoomba(serRoomba);
        pause(.5)
        SetLEDsRoomba(serRoomba,1,0,100);
    else
        i=1;
    end
    if(all(ButtonsAll))
        %both buttons were pressed
        %so leave this function and return to accept a new command sequence
        run_execute=0;
    else
        if(BumpSensors>0 || ButtonsAll(1)==1 || whlDrop==1)
            %if robot hit wall or someone pressed next tthen reset the
            %command sequence to the beginning
            i=1;
        end
        ButtonsAll=[0 0];
        whlDrop=0;
        while(ButtonsAll(2)==0)
            [BumpSensors ButtonsAll] = Check_Sensors(serRoomba);
            %if one button is pressed then delay and see if user meant to
            %press one or both buttons by reading again
            if(sum(ButtonsAll)==1)
                pause(.1)
                [BumpSensors ButtonsAll]=Check_Sensors(serRoomba);
            end
            if(all(ButtonsAll))
                run_execute=0;
            elseif(ButtonsAll(1)==1)
                i=1;
                SetLEDsRoomba(serRoomba,3,100,100);
                BeepRoomba(serRoomba);
                pause(.5)
                SetLEDsRoomba(serRoomba,1,0,100);
            end
        end
        SetLEDsRoomba(serRoomba,1,100,100);
        BeepRoomba(serRoomba);
        pause(.5)
        SetLEDsRoomba(serRoomba,1,0,100);
        
    end
end
%stop the roomba
SetFwdVelRadiusRoomba(serRoomba,0,inf);
    
end
