/*
*  ThreeOscInstrument
*  Author: Ian Effendi
*  Instrument must be implemented by classes that wish to be used with Minim.
*
*  Referenced Minim API docs for ADSR, Line, and Oscil.
*/
class ThreeOscInstrument implements Instrument {
  Summer wave; // Summer that joins the oscillators.
  
  Oscil[] oscs; // Oscillators.
  ADSR[] gates; // ADSR gate.
  Line[] ampEnvs; // Envelope to articulate cleanly.
  
  /*
    Takes three frequencies, one for each oscillator, and three waveforms.
  */
  ThreeOscInstrument(OscillatorSettings[] os, float[] freqs, Waveform[] waves){
    oscs = new Oscil[3];
    gates = new ADSR[3];
    ampEnvs = new Line[3];    
    wave = new Summer();
    
    // Create each new oscillator.
    for(int i = 0; i < oscs.length; i++) {
      oscs[i] = new Oscil(freqs[i], 0.5, waves[i]);
      gates[i] = new ADSR(os[i].getAmplitude(), os[i].getAttack(), os[i].getDecay(), os[i].getSustain(), os[i].getRelease());
      oscs[i].patch( gates[i] );
      ampEnvs[i] = new Line();
      ampEnvs[i].patch( oscs[i].amplitude ); // Patch amplitude.
    }
    
    wave.patch( out );
  } 
  
  // Return the output for each individual oscillator's amplitude. 
  Line getLineOut(int oscIndex) {
    if(oscIndex < 0 || oscIndex >= oscs.length) {
       return null; 
    }
    return ampEnvs[oscIndex];
  }
  
  void noteOn(float duration) {
    // Attach oscilator to the output to make sound.
    // wave.patch(out);
    // ampEnvs[0].activate(duration, 0.20f, 0);
    
    for(int i = 0; i < oscs.length; i++) {
      gates[i].noteOn();
      gates[i].patch( wave );
    }
  }
  
  // Called when the instrument should stop making a sound.
  void noteOff() {
    // wave.unpatch( out );
    for(int i = 0; i < oscs.length; i++) {
      gates[i].noteOff();
      gates[i].unpatchAfterRelease( wave );
    }    
  }  
  
}
