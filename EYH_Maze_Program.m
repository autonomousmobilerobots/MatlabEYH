function [] = EYH_Maze_Program(serRoomba)
%create infinite loop so we don't have to reinitialize the program
% cur_dir=pwd;
% cd '..\MatlabToolboxiRobotCreate\';
% addpath(pwd);
% cd(cur_dir);

%initialize Roomba
% serRoomba = RoombaInit(serPort);
SetLEDsRoomba(serRoomba,0,100,100);

%Specify the length of a single command as 5, to change need to change
%command library in Execute_Commands.m
length_Single_Command = 5;

%wait for play button input to start program
ButtonsAll = [0 0];
fprintf('Waiting to start the program...Press PLAY and PAUSE\n')
while any(~ButtonsAll)
    [BumpSensors ButtonsAll] = Check_Sensors(serRoomba);
end
SetLEDsRoomba(serRoomba,0,100,100);
BeepRoomba(serRoomba);
pause(.3)
%take in the inputs from the bump sensors
%Command Input Mode
while(1)
    [cmd_seq] = Accept_Commands(serRoomba);
    disp('Command Sequence')
    disp(cmd_seq)
    
    %execute the program
    Execute_Commands(serRoomba,cmd_seq)

end

end