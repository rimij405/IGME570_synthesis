/*
*  SineInstrument
*  Author: Ian Effendi
*  Instrument must be implemented by classes that wish to be used with Minim.
*/
class SineInstrument implements Instrument {
  Oscil wave; // Oscillator to create sound.
  Line ampEnv; // Envelope to articulate cleanly.
  
  SineInstrument(float frequency){
    wave = new Oscil(frequency, 0, Waves.SINE);
    ampEnv = new Line();
    ampEnv.patch(wave.amplitude);
  }
  
  void noteOn(float duration) {
    // Attach oscilator to the output to make sound.
    wave.patch(out);
    ampEnv.activate(duration, 0.20f, 0);
  }
  
  // Called when the instrument should stop making a sound.
  void noteOff() {
    wave.unpatch(out);
  }
  
  
  
}
