# DIY Pinball Machine


## OVERVIEW
Co-created an advanced pinball machine featuring custom 3D printed/laser-cut components, solenoid-operated flippers, IR sensor-based scoring, dual seven-segment score displays, motor-driven obstacles, a precision plunger, and a piezoelectric reset system.
Team Members:
1. Veeraj Vishnu
2. Nghi Lu
3. Christian Hendrick
## Demo

## Functionality Goals

1. Paddle propels ball across playfield.
2. Ball introduced via plunger.
3. Multiple scoring mechanisms (2 IR sensors).
4. Seven-segment display for score tracking.
5. Piezo detects round loss and resets score.
6. Start/stop button for system control.
7. Game resets on system start and round completion.
8. Ball gravitates towards paddles.
9. Visually appealing design.

10. Special Requirements:
...* Electronically activated paddle(s).
...* Auditory score feedback.
...* Ball-detecting actuators (flippers).
...* Optical sensors for two applications.
...* Integration of electric motors, solenoids, and RC servos.
...* Automated gating mechanism for ball handling between rounds.

## Final Trace Matrix
• Final trace matrix 
| Spec. Number | Spec. Description                   | Test to perform             | Measured values |
|--------------|-------------------------------------|-----------------------------|-----------------|
| 1            | Paddle propels ball across playfield | Testing the flippers        | The flippers work better than expected. The ball reach far end to the target |
| 2            | Ball introduced via plunger         | Start game button is installed | The plunger worked as expected |
| 3            | Multiple scoring mechanisms (2 IR sensors) | Testing the sensor          | Current score and current factor will increase as designed |
| 4            | Seven-segment display for score tracking | 7 segment testing           | The score is going up as expected and the buzzer goes off every time. Also, when it reaches 99, the buzzer will go off all the way |
| 5            | Piezo detects round loss and resets score | Testing reset feature     | Player will have to push the flat buzzer which is covered by a black octopus to reset the point to 0 (meaning you lost the game, play again) |
| 6            | Start/stop button for system control | Start/stop button           | We placed the on/off button on the side of the machine - works as expected |
| 7            | Game resets on system start and round completion | This feature is included in feature 5 | When the player presses the flat buzzer, the sensor gat will be opened, and the ball will enter the play field again |
| 8            | Ball gravitates towards paddles     | Place pinball on 10 random spots of the playfield | The pinball always moves towards the flippers |
