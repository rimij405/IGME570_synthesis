class OscillatorSettings {

  int id;
  float amplitude;
  float attack;
  float decay;
  float sustain;
  float release;
  int waveformID;
    // Set default settings.
  OscillatorSettings(int oscillatorID) {
    
     // Set the ID.
     id = oscillatorID;
     
     // Set the default.
     amplitude = 1.0;
     attack = 0.04;
     decay = 0.01;
     sustain = 1.0;
     release = 0.1;
     waveformID = 1;    
  }
  
  public String toString() {
    String settings = "";
    
    settings += "Osc (" + getID() + ") ";
    settings += "[AMP::" + getAmplitude() + "] ";
    settings += "[ATK::" + getAttack() + "] ";
    settings += "[DEC::" + getDecay() + "] ";
    settings += "[SUS::" + getSustain() + "] ";
    settings += "[REL::" + getRelease() + "] ";
    settings += "[WAVE::" + getWaveformName() + "]";
    
    return settings;
  }
  
  private String getWaveformName() {
    switch(getWaveformID()) {
      case '1':
        return "SINE";
      case '2':
        return "TRIANGLE";
      case '3':
        return "SAW";
      case '4':
        return "SQUARE";
      case '5':
        return "QUARTERPULSE";
    }
    return "NULL";
  }
  
  public int getID() {
    return id;
  }
  
  void setID(int value) {
    if(value < 0) {
      id = 0; 
    }
    if(value > 2) {
      id = 2;
    }
  }
  
  public float getAmplitude() {
    return amplitude;
  }
  
  public void setAmplitude(float value) {
    amplitude = constrain(value, 0.0, 1.0);
  }
  
  public float getAttack() {
    return attack;
  }
  
  public void setAttack(float value) {
    attack = constrain(value, 0.0, 1.0);
  }
  
  public float getDecay() {
    return decay;
  }
  
  public void setDecay(float value) {
    decay = constrain(value, 0.0, 1.0);
  }
  
  public float getSustain() {
    return sustain;
  }
  
  public void setSustain(float value) {
    sustain = constrain(value, 0.0, 1.0);
  }
  
  public float getRelease() {
    return release;
  }
  
  public void setRelease(float value) {
    release = constrain(value, 0.0, 1.0);
  }
  
  public int getWaveformID() {
    return waveformID;
  }
  
  public void setWaveformID(int value) {
    waveformID = value;
    if(waveformID > 5) {
      waveformID = 1;
    }
    if(waveformID <= 0) {
      waveformID = 1;
    }
  }
  
  // Process input from the keyboard.
  public void processInput(String input){
    if(input != null) {
      switch(input) {
        // Toggle Waveform ID.
        case "1":
          setWaveformID(getWaveformID() + 1);
          break;
          
        // Increase attack.
        case "]":
          setAttack(getAttack() + 0.05);
          break;
        // Decrease attack.
        case "[":
          setAttack(getAttack() - 0.05);
          break;
          
        // decay
        case "+":
          setDecay(getDecay() + 0.05);
          break;
        case "-":
          setDecay(getDecay() - 0.05);
          break;
          
        // amplitude
        case ".":
          setAmplitude(getAmplitude() + 0.25);
          break;
        case ",":
          setAmplitude(getAmplitude() - 0.25);
          break;
          
      }
    }
  }

}
