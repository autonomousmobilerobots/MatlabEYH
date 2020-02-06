function [] = EYH_Start(RobotName)
% function [] = EYH_Start(RobotName)
% Run this function to start a new EYH session.
% The full Create Matlab toolbox needs to be in the path  
%
% RobotName = A string with the name of the Create you want to connect to
%
% This function will call the Init functions from the Create Matlab toolbox
% then wait for a prompt from the user to make sure the connection has been
% properly established, and run the main Maze program.


% Call DebugPiInit function to initialize connection with the robot 
Port = DebugPiInit(RobotName);

% Make sure all the init stuff is done
prompt = 'Look at the terminal command window. Does it say "Ready for Commands!"? y/n [y] ';
str = input(prompt,'s');
if isempty(str)
    str = 'y';
end

% Run the maze program if all looks good. Otherwise stop and return.
if (strcmpi(str,'y'))
    disp('Running Maze Program')
    EYH_Maze_Program(Port);
else 
    disp('Something did not go as planned - shutting down. Is the robot on? Try again!')
    DebugPiShutdown(Port);
    return;
end
