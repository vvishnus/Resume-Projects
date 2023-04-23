#define SRCLK1 9
#define RCLK1  7
#define SER1   4

#define SRCLK2 10
#define RCLK2  8
#define SER2   5

#define SENSOR 2    // scoring sensor 1

#define zero B11111100
#define one B01100000
#define two B11011010
#define three B11110010
#define four B01100110
#define five B10110110
#define six B10111110
#define seven B11100000
#define eight B11111110
#define nine B11110110

int digits[10] = {zero,one,two,three,four,five,six,seven,eight,nine};
int score = 0;
bool flag = false;
int firstDigit;
int secondDigit;

void setup() {
  Serial.begin(9600);
  pinMode(SRCLK1, OUTPUT); // pin 9 // 7 segment display
  pinMode(RCLK1, OUTPUT); // pin 7
  pinMode(SER1, OUTPUT); // pin 4
  pinMode(SRCLK2, OUTPUT); // pin 9 // 7 segment display
  pinMode(RCLK2, OUTPUT); // pin 7
  pinMode(SER2, OUTPUT); // pin 4
}

void loop() {
  // put your main code here, to run repeatedly:


  int sensor_state = digitalRead(SENSOR);
    firstDigit = score / 10;
    secondDigit = score % 10;
    if ((sensor_state == 0) && (flag == true) && (score < 99)) { // 0 means that ball is on the sensor
      score += 1;
      Serial.println("hello");
      flag = false;
    }
  
    if ((sensor_state == 1) && (flag == false) && (score < 99)){
      flag = true;
    }

//    if (score > 99){
//      digitalWrite(RCLK1, LOW);
//      shiftOut(SER1, SRCLK1, LSBFIRST, B10001110);
//      digitalWrite(RCLK1, HIGH);
//      digitalWrite(RCLK2, LOW);
//      shiftOut(SER2, SRCLK2, LSBFIRST, B10001110);
//      digitalWrite(RCLK2, HIGH);
//    }
    
    digitalWrite(RCLK1, LOW);
    shiftOut(SER1, SRCLK1, LSBFIRST, digits[firstDigit]);
    digitalWrite(RCLK1, HIGH);
    digitalWrite(RCLK2, LOW);
    shiftOut(SER2, SRCLK2, LSBFIRST, digits[secondDigit]);
    digitalWrite(RCLK2, HIGH);


 

//  for (int i = 0; i<10; i++){
//    digitalWrite(RCLK1, LOW);
//    shiftOut(SER1, SRCLK1, LSBFIRST, digits[i]);
//    digitalWrite(RCLK1, HIGH);
//    delay(500);
//  }
//
//    for (int j = 0; j<10; j++){
//    digitalWrite(RCLK2, LOW);
//    shiftOut(SER2, SRCLK2, LSBFIRST, digits[j]);
//    digitalWrite(RCLK2, HIGH);
//    delay(500);
//  }
}
