function [] = EYH_Start(RobotName)
% function [] = EYH_Start(RobotName)
% Run this function to start a new EYH session.
%
% RobotName = A string with the name of the Create you want to connect to
%
% This function will call the Init functions from the Create Matlab toolbox
% then wait for a prompt from the user to make sure the connection has been
% properly established, and run the main Maze program.


% Call CreatePiInit function to initialize connection with the robot 
Ports = CreatePiInit(RobotName);
CreatePort = Ports.create;

% Make sure all the init stuff is done
prompt = 'Look at the terminal command window. Does it say "Ready for Commands!"? y/n [y] ';
str = input(prompt,'s');
if isempty(str)
    str = 'y';
end

% Run the maze program if all good.
if (strcmp(str,'y') || strcmp(str,'Y'))
    disp('Running Maze Program')
    EYH_Maze_Program(CreatePort);
else 
    disp('Something did not go as planned - shutting down. Is the robot on? Try again!')
    CreatePiShutdown(Ports);
    return;
end
    

