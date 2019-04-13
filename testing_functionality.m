%%
while(1)
    Check_Sensors(ports.create);
    pause(.2)
end

%%
SetLEDsRoomba(ports.create,2,100,100);
BeepRoomba(ports.create);
pause(.15)
SetLEDsRoomba(ports.create,0,100,100);
pause(.15)
SetLEDsRoomba(ports.create,2,100,100);
pause(.2)
SetLEDsRoomba(ports.create,0,0,100);

%%
BeepRoomba(ports.create);
pause(.3)
BeepRoomba(ports.create);
%%
SetLEDsRoomba(serRoomba,2,100,100);
                BeepRoomba(serRoomba);
                pause(0.5);
                %turn back to Play light, Power to Green
                SetLEDsRoomba(serRoomba,0,0,100);