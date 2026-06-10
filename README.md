# Self-Balancing Robot

A two-wheeled inverted pendulum robot that balances upright using 
real-time PID control. Built as an independent project to apply 
control theory, embedded programming, and mechanical design.

## Status
🔬 Phase 1 Complete — Simulation & Modelling  
🔨 Phase 2 In Progress — Chassis Design (Fusion 360)

## Stack
- **Microcontroller:** Arduino Nano (ATmega328P)
- **Sensor:** MPU-6050 IMU (accelerometer + gyroscope)
- **Actuators:** TT DC gear motors (200RPM) via L298N driver
- **Chassis:** Custom design in Fusion 360, 3D printed
- **Control:** PID algorithm in Arduino C++
- **Data logging:** Python + matplotlib for tuning analysis

## Simulation & Modelling

Before building the hardware, the system was modelled mathematically 
as an inverted pendulum and simulated in both MATLAB and Simulink.

### MATLAB PID Script
Implemented a discrete-time PID simulation at 200Hz matching the 
Arduino control loop frequency. Systematically varied Kp, Ki, and Kd 
to understand each term's physical effect on the robot.

Key finding: Kp=40 insufficient to overcome gravity in this model. 
Kp=200 with Kd=6 produced stable damped oscillation settling within 
1.5 seconds. High Kd (≥25) over-damped the system eliminating 
corrective response entirely.

![Baseline PID Response](Simulation/run2_high_kp.png)

### Simulink Block Diagram Model
Built a full closed-loop Simulink model of the inverted pendulum 
with a PID Controller block, gravity torque via sin(θ) feedback, 
and dual integrators for the plant physics. Used the Simulink PID 
Tuner to explore the trade-off between response speed and stability.


**Hardware starting gains: Kp=200, Ki=0, Kd=6**

## Project Goals
- [x] Design MATLAB PID simulation
- [x] Build Simulink closed-loop model
- [x] Tune gains using Simulink PID Tuner
- [ ] Design chassis in Fusion 360
- [ ] Wire MPU-6050 and verify IMU readings
- [ ] Implement PID control loop on Arduino
- [ ] Tune PID gains on real hardware
- [ ] Log and visualize tuning data in Python
- [ ] Record demo video

## Build Log
**June 2026** — Completed simulation phase. MATLAB and Simulink models 
both confirm stable balance is achievable with Kp=200, Kd=6. 
Hardware arriving shortly — moving to chassis design.

## Connect
- LinkedIn: [linkedin.com/in/nischay-rawat](https://linkedin.com/in/nischay-rawat)
- Email: nischay179@gmail.com
