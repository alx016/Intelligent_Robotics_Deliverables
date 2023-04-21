function [vl, vr] = controlRobotMovilCoopelia(x, y, theta, xd, yd) 
    % Define robot parameters
    wheelbase = 0.381; % distance between wheels (m) (l)
    dt = 0.01; % time step (s)
    t = 0; % Total time (s)
    % v = 1; % maximum linear velocity (m/s)
    % w = pi/2; % maximum angular velocity (rad/s)
    
    % Define desired position
    kpr = 4.0;
    kpt = 4.0;
    vmax = 1;
    
    % i = 1;
    while t < 5

        thetad = atan2((yd-y),(xd-x));
        d = sqrt((xd-x)^2 + (yd-y)^2);
    
        thetae = (theta-thetad);
        if thetae > pi
            thetae = thetae - 2*pi;
        elseif thetae < -pi
            thetae = thetae + 2*pi;
        end
    
        % w = -kpr*thetae;
        % v = kpt*d;

        w = -kpr*tanh(thetae);
        v = vmax*tanh((kpt*d)/vmax);
        
        vr = v + (wheelbase*w)/2; %% Esto iría al PWM
        vl = v - (wheelbase*w)/2; %% Esto iría al PWM
        t = t + dt;
    end

end