# PID Gains — Physical Intuition
## Nischay Rawat | Self-Balancing Robot | Summer 2026

## The Idea
Gravity constantly tries to tip the robot over. The PID controller 
decides how hard to drive the motors to correct the lean. Three terms, 
each doing a different job.

## P — Proportional
Responds to how far the robot is leaning right now.
Too low -> falls over, correction too weak to fight gravity.
Too high -> overcorrects and oscillates wildly.
Simulation finding: Kp=40 failed completely, Kp=200 achieved stable balance.

## D — Derivative
Responds to how fast the angle is currently changing. Acts as a brake — 
dampens the oscillation that Kp creates.
Too low -> bounces forever, never settles (confirmed in Run 3, Kd=0).
Too high -> over-damped, motors barely respond and robot tips slowly (Run 4).

## I — Integral
Responds to accumulated error over time. Corrects small persistent drift 
that P alone can't eliminate.
Too low -> robot settles slightly off upright.
Too high -> slow wobbling instability.
Always set to zero first, add last after Kp and Kd are stable.

## Tuning Order
1. Kp only until it tries to balance but oscillates
2. Add Kd until oscillations dampen
3. Add small Ki to clean up remaining drift

## Hardware Starting Gains
Kp=200, Ki=0, Kd=6