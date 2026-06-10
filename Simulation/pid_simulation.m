%% Self-Balancing Robot — PID Simulation
%% ================================================

%% SECTION 1: SYSTEM PARAMETERS
% Description of the Robot
g = 9.81;       % gravitational acceleration (m/s²) — fixed constant
L = 0.10;       % estimate of the distance from wheel axle to robot's centre of mass (metres)

%% SECTION 2: PID GAINS
% The three values that tune the controller
Kp = 150;        % Proportional gain
                % Think: "how hard do I respond to how far I'm leaning right now"
                % Too low = robot slowly tips over, doesn't correct fast enough
                % Too high = robot overcorrects and oscillates wildly

Ki = 2;         % Integral gain — START AT ZERO, always
                % Think: "how hard do I respond to accumulated lean over time"
                % Corrects slow drift but destabilises if added too early
                % We add this last, after Kp and Kd are tuned

Kd = 25;         % Derivative gain
                % Think: "how hard do I respond to how fast I'm currently falling"
                % Acts like a brake — dampens oscillations caused by Kp
                % Too low = bouncy oscillation, Too high = jittery/noisy response
     
%% SECTION 3: SIMULATION SETTINGS
dt = 0.005;         % timestep = 5 milliseconds
                    % the simulation recalculates everything every 5ms
                    % matches Arduino loop speed — gains transfer directly to hardware

t = 0 : dt : 5;    % time vector from 0 to 5 seconds, stepping by 0.005
                    % creates array: [0, 0.005, 0.010, ..., 4.995, 5.000]
                    
%% SECTION 4: INITIAL CONDITIONS
theta      = 0.05;  % starting tilt angle in RADIANS (~3 degrees)
                    % simulates placing the robot down slightly off-balance
                    % if you start at exactly 0, nothing happens — perfectly balanced
                    % 0.05 rad is realistic for how steady your hand will be

theta_dot  = 0;     % starting angular velocity = 0 (not moving yet)
integral   = 0;     % integral term starts empty
prev_error = theta; % previous error = starting angle (needed for derivative calc)

%% SECTION 5: STORAGE ARRAYS
% Pre-allocate arrays to store results at each timestep
% Much faster than growing arrays inside the loop
theta_log  = zeros(size(t));   % will store angle at every timestep
output_log = zeros(size(t));   % will store motor command at every timestep

%% SECTION 6: THE SIMULATION LOOP
% This is the heart of everything — runs once per timestep
for i = 1:length(t)

    %% --- PID CALCULATION ---
    
    error = theta;
    % The setpoint is 0 degrees (perfectly upright)
    % Error = how far we are from the setpoint = just the angle itself
    % Positive angle = leaning forward = need to drive forward to correct
    
    integral = integral + error * dt;
    % Integral accumulates error over time (area under the error curve)
    % Multiplied by dt to get correct units
    % Grows large if robot drifts slowly in one direction for a long time
    
    derivative = (error - prev_error) / dt;
    % Rate of change of error = how fast the angle is currently changing
    % If error is growing fast, derivative is large = apply more braking
    % If error is shrinking (improving), derivative is negative = ease off
    
    output = Kp*error + Ki*integral + Kd*derivative;
    % The three PID terms added together = total motor command
    % Positive output = drive forward, Negative output = drive backward
    
    output = max(min(output, 255), -255);
    % Clamp to Arduino PWM range (-255 to 255)
    % Motors can't go beyond full speed in either direction
    % Without this, the math can produce impossible values like 10,000

    %% --- PHYSICS CALCULATION ---
    
    theta_ddot = (g/L)*sin(theta) - (output/255)*(g/L)*2;
    % Angular acceleration = gravity effect MINUS motor correction effect
    %
    % (g/L)*sin(theta) = how hard gravity is currently pulling the robot over
    %   when theta is small, sin(theta) ≈ theta, so nearly linear
    %   this term is always trying to increase the tilt (destabilising)
    %
    % (output/255)*(g/L)*2 = how hard the motors are pushing back
    %   output/255 normalises motor command to 0-1 range
    %   when output matches gravity perfectly, acceleration = 0 = balanced
    
    theta_dot = theta_dot + theta_ddot * dt;
    % Update angular velocity using acceleration
    % Euler integration: new velocity = old velocity + acceleration × time
    
    theta = theta + theta_dot * dt;
    % Update angle using velocity
    % Euler integration again: new angle = old angle + velocity × time
    % This is the new angle the PID will react to in the next iteration
    
    prev_error = error;
    % Store this iteration's error for next iteration's derivative calculation
    
    %% --- LOG RESULTS ---
    theta_log(i)  = theta;    % save angle for plotting
    output_log(i) = output;   % save motor command for plotting

end
%% SECTION 7: PLOTTING
figure;

subplot(2,1,1);
% Top plot — angle over time
plot(t, rad2deg(theta_log), 'b', 'LineWidth', 1.5);
% rad2deg converts radians to degrees — easier to read
xlabel('Time (s)');
ylabel('Tilt Angle (degrees)');
title('Robot Tilt Angle over Time');
yline(0, '--r', 'Upright = 0°');
grid on;

subplot(2,1,2);
% Bottom plot — motor command over time
plot(t, output_log, 'g', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Motor Command (PWM -255 to 255)');
title('PID Motor Output');
yline(0, '--r');
grid on;