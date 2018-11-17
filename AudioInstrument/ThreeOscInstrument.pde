/*
*  ThreeOscInstrument
*  Author: Ian Effendi
*  Instrument must be implemented by classes that wish to be used with Minim.
*/
class ThreeOscInstrument implements Instrument {
  Oscil osc1; // Oscillator 1.
  Oscil osc2; // Oscillator 2.
  Oscil osc3; // Oscillator 3.
  Summer wave; // Summer that joins the oscillators.
  
  Line ampEnv; // Envelope to articulate cleanly.
  
  /*
    Takes three frequencies, one for each oscillator, and three waveforms.
  */
  ThreeOscInstrument(float f1, Waveform w1, float f2, Waveform w2, float f3, Waveform w3){
    osc1 = new Oscil(f1, 0, w1);
    osc2 = new Oscil(f2, 0, w2);
    osc3 = new Oscil(f3, 0, w3);
    
    wave = new Summer();
    osc1.patch( wave );
    osc2.patch( wave );
    osc3.patch( wave );
  
    ampEnv = new Line();
    ampEnv.patch( osc1.amplitude );
    ampEnv.patch( osc2.amplitude );
    ampEnv.patch( osc3.amplitude );
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
