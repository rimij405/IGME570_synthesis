/*
*   AudioInstrument 
*   Author: Ian Effendi
*   This creates an instrument that can be played.
*
*   Referenced class files provided by Al Biles.
*/

import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;

String lastKeyPress;
int currentOscillator;
OscillatorSettings[] oscSettings;

void setup(){
  
  // Initialize GUI and Minim object.
  size(812, 400);  
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
  
  // Select background and stroke colors.
  background(64, 32, 0);
  int[][] colors = new int[4][];
  for(int i = 0; i < colors.length; i++) {
    colors[i] = new int[3];
  }
  
  switch(currentOscillator) {
    case 0:
      stroke(255, 0, 0);
      break;
    case 1:
      stroke(0, 255, 0);
      break;
    case 2:
      stroke(0, 0, 192);
      break;
    default:
      stroke(255, 238, 192);
      break;
  }
  
  // Draw text messages to the screen.
  String lastInput = (lastKeyPress != null) ? lastKeyPress : "No Keys Pressed";
  text( "Created by Ian Effendi | qrtyio - Black Keys | asdfghjkl;' - White Keys | [Last Key Press = \"" + lastInput + "\"]", 5, 15);  
  text( "Controls: Cycle Oscillator Selection (*) | Toggle Waveform (1) | Inc/Dec DETUNE ()/() | Inc/Dec ATK (]/[)", 5, 30);
  text( "          Inc/Dec DEC (+/_) | Inc/Dec AMP (./,) | Inc/Dec SUS (}/{) | Inc/Dec REL (=/-)", 5, 45);
  text( "Current Selection - [Osc::" + currentOscillator + "]", 5, 60);
  for(int oscIndex = 0; oscIndex < oscSettings.length; oscIndex++) {
    text( oscSettings[oscIndex].toString(), 5, 75 + (oscIndex * 15));    
  }
  
  // Draw waveforms in real time
  for (int i = 0; i < out.bufferSize() - 1; i++)
  {
    float x1 = map(i, 0, out.bufferSize(), 0, width);
    float x2 = map(i + 1, 0, out.bufferSize(), 0, width);
    line( x1, 150 + out.left.get(i)*50, x2, 155 + out.left.get(i+1)*50 );
    line( x1, 200 + out.right.get(i)*50, x2, 205 + out.right.get(i+1)*50 );
  }
}

// Implement a piano keyboard on the computer keyboard with the "asdf" row
// being the white keys and the "qwerty" row being the black keys
void keyPressed()
{
  // Update the oscillator settings.
  updateOscillatorSettings(str(key));
  
  // Determine key to play.
  lastKeyPress = str(key);
  String pitch = getPitch(str(key));
  playANote(pitch);
  
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
  
  if(input.equals("a")) return "C4";
  if(input.equals("q")) return "C#4";
  if(input.equals("s")) return "D4";
  if(input.equals("w")) return "D#4";
  if(input.equals("d")) return "E4";
  if(input.equals("f")) return "F4";
  if(input.equals("r")) return "F#4";
  if(input.equals("g")) return "G4";
  if(input.equals("t")) return "G#4";
  if(input.equals("h")) return "A4";
  if(input.equals("y")) return "A#4";
  if(input.equals("j")) return "B4";
  if(input.equals("k")) return "C5";
  if(input.equals("i")) return "C#5";  
  if(input.equals("l")) return "D5";
  if(input.equals("o")) return "D#5";
  if(input.equals(";")) return "E5";
  if(input.equals("'")) return "F5";
  if(input.equals("z")) return "G5";
  if(input.equals("x")) return "A5";
  if(input.equals("c")) return "B5";
  if(input.equals("v")) return "C6";
  
  return null;
}

// Generates a new ThreeOscInstrument with the proper settings.
ThreeOscInstrument create3OscInstrument(String pitch) {
  float[] f  = new float[3];
  Waveform[] w = new Waveform[3];
  
  // For each oscillator setting, apply the proper values.
  for(int i = 0; i < oscSettings.length; i++) {
    if(pitch != null) {
      f[i] = getFrequency(pitch) + oscSettings[i].getDetune();
    } else {
      f[i] = Frequency.ofHertz( 440 ).asHz();
    }
    w[i] = getWaveform(oscSettings[i].getWaveformID());
  }
  
  return new ThreeOscInstrument(oscSettings, f, w);
}

// Play a note with the three oscillator generator.
void playANote(String pitch) {
  println("What is pitch? " + pitch);
  if(pitch != null) {   
    lastKeyPress = pitch;
    println("Reaches here.");
    out.playNote(0.0, 1.0, create3OscInstrument(pitch));
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
