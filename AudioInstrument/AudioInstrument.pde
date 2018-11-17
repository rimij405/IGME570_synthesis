/*
*   AudioInstrument 
*   Author: Ian Effendi
*   This creates an instrument that can be played.
*/

import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;

int currentOscillator;
OscillatorSettings[] oscSettings;

void setup(){
  
  // Initialize GUI and Minim object.
  size(512, 200);  
  minim = new Minim(this);
  
  // Prepare the currently selected oscillator information.
  currentOscillator = 0;
  oscSettings = new OscillatorSettings[3];
  for(int i = 0; i < oscSettings.length; i++) {
    oscSettings[i] = new OscillatorSettings(i);
  }  
  
  // Get the AudioOutput.
  out = minim.getLineOut();
  
}

/* Draw waveforms out to the GUI. */
void draw(){
  background(0);
  stroke(255);

  // Draw waveforms in real time
  for (int i = 0; i < out.bufferSize() - 1; i++)
  {
    line( i, 50 + out.left.get(i)*50, i+1, 50 + out.left.get(i+1)*50 );
    line( i, 150 + out.right.get(i)*50, i+1, 150 + out.right.get(i+1)*50 );
  }
}

// Implement a piano keyboard on the computer keyboard with the "asdf" row
// being the white keys and the "qwerty" row being the black keys
void keyPressed()
{
  // Update the oscillator settings.
  updateOscillatorSettings(str(key));
  
  // Determine key to play.
  
  
  
  
  
  
 
  if (pitch != null) {
    float f1 = Frequency.ofPitch(pitch).asHz();
    Waveform w1 = Waves.SINE;
    out.playNote(0.0, 1.0, new ThreeOscInstrument(f1, w1, f1, w1, f1, w1));
    
    // out.playNote(0.0, 1.0, new SineInstrument(Frequency.ofPitch(pitch).asHz()));
  }
}

// Handle input to update oscillator settings.
void updateOscillatorSettings(String input) {
  if(input != null) {
    switch(input) {
      // Cycle to manipulate the next oscillator in the cycle.
      case "*":
        cycleSelectedOscillator();
        break;
        
      // Process the input for the current oscillator.
      default:
        oscSettings[currentOscillator].processInput(input); 
        break;
    }   
  }  
}

String getPitch(String input) {
  
  // Handle pitch input processing.
  if(input == "a") return "C4";
  if(input == "q") return "C#4";
  if(input == "s") return "D4";
  if(input == "w") return "D#4";
  if(input == "d") return "E4";
  if(input == "f") return "F4";
  if(input == "r") return "F#4";
  if(input == "g") return "G4";
  if(input == "t") return "G#4";
  if(input == "h") return "A4";
  if(input == "y") return "A#4";
  if(input == "j") return "B4";
  if(input == "k") return "C5";
  if(input == "i") return "C#5";  
  if(input == "l") return "D5";
  if(input == "o") return "D#5";
  if(input == ";") return "E5";
  if(input == "'") return "F5";
  if(input == "z") return "G5";
  if(input == "x") return "A5";
  if(input == "c") return "B5";
  if(input == "v") return "C6"; 
  
  return null;
}

// Play a note with the three oscillator generator.
void playNote(String pitch, int[] waveforms) {
  if(pitch != null) {
    float[] freqs = new float[3];
    freqs[0] = getFrequency(pitch);
    freqs[1] = getFrequency(pitch);
    freqs[2] = getFrequency(pitch);
    
    Waveform[] waves = new Waveform[3];
    waves[0] = getWaveform(waveforms[0]);
    waves[1] = getWaveform(waveforms[1]);
    waves[2] = getWaveform(waveforms[2]);
    
    out.playNote(0.0, 1.0, new ThreeOscInstrument(freqs[0], waves[0], freqs[1], waves[1], freqs[2], waves[2]));
  }
}

float getFrequency(String pitch) {
  return Frequency.ofPitch(pitch).asHz();
}

Waveform getWaveform(int number) {
  switch(number) {
    case 1:
      return Waves.SINE;
    case 2:
      return Waves.TRIANGLE;
    case 3:
      return Waves.SAW;
    case 4:
      return Waves.SQUARE;
    case 5:
      return Waves.QUARTERPULSE;
  }
  
  return Waves.SINE;
}

// Cycle oscillator selection.
void cycleSelectedOscillator() {
  currentOscillator++;
  if(currentOscillator >= oscSettings.length){
    currentOscillator = 0;
  }
}
