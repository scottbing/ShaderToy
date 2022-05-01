PShader seascape;

HelperFunctions hf = new HelperFunctions();

void setup() {
 size(640, 360, P2D); 
 noStroke();

 seascape = loadShader("seascape.glsl"); 
 seascape.set("iResolution", float(width), float(height));
 seascape.set("time", millis() / 500.0);

}

void draw() {
 shader(seascape);
 rect(0.0, 0.0, width, height);
 seascape.set("time", millis() / 500.0);
}

void keyPressed() {
  if (key==' ') {
    hf.save("img");
  }
}
