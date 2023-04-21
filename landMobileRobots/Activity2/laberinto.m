close all
clear all
clc

[xd, yd] = mapCreator();
% xd = x;
% yd = y;
% Inicialización con Coppelia
sim=remApi('remoteApi'); % usando el prototipo de función (remoteApiProto.m)
sim.simxFinish(-1); % Cerrar las conexiones anteriores en caso de que exista una
clientID=sim.simxStart('127.0.0.1',19999,true,true,5000,5);

%% Verificación de la conexión
if (clientID>-1)
    disp('Conexión con Coppelia iniciada');
    %Preparación
    [returnCode, left_motor] = sim.simxGetObjectHandle(clientID, 'Pioneer_p3dx_leftMotor', sim.simx_opmode_blocking);
    [returnCode, right_motor] = sim.simxGetObjectHandle(clientID, 'Pioneer_p3dx_rightMotor', sim.simx_opmode_blocking);
    [returnCode, robot] = sim.simxGetObjectHandle(clientID, 'Pioneer_p3dx', sim.simx_opmode_blocking);
    % Acciones
    [returnCode, orientation] = sim.simxGetObjectOrientation(clientID, robot, -1,sim.simx_opmode_blocking);
    [returnCode, position] = sim.simxGetObjectPosition(clientID, robot, -1, sim.simx_opmode_blocking);
        
    for n = 1:length(xd)
        d = sqrt ((xd(n) - position(1))^2 + (yd(n) - position(2))^2);
        while (d > 0.15)
            [vl, vr] = controlRobotMovilCoopelia(position(1), position(2), orientation(3), xd(n), yd(n));
            [returnCode] = sim.simxSetJointTargetVelocity(clientID, left_motor, vl, sim.simx_opmode_blocking);
            [returnCode] = sim.simxSetJointTargetVelocity(clientID, right_motor, vr, sim.simx_opmode_blocking);
            [returnCode, orientation] = sim.simxGetObjectOrientation(clientID, robot, -1,sim.simx_opmode_blocking);
            [returnCode, position] = sim.simxGetObjectPosition(clientID, robot, -1, sim.simx_opmode_blocking);
            d = sqrt ((xd(n) - position(1))^2 + (yd(n) - position(2))^2);
            figure(1)
            plot(xd, yd, 'x')
            hold on
            plot(position(1), position(2), 'o')
            axis([0 5 0 5])
            grid on
            pause(0.1)
        end
    end

    [returnCode] = sim.simxSetJointTargetVelocity(clientID, left_motor, 0, sim.simx_opmode_blocking);
    [returnCode] = sim.simxSetJointTargetVelocity(clientID, right_motor, 0, sim.simx_opmode_blocking);
    
    disp('Conexión con Coppelia terminada');
    sim.simxFinish(clientID);
end
sim.delete(); % Llamar al destructor!
