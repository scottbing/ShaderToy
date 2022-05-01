PShader rave;

HelperFunctions hf = new HelperFunctions();

void setup() {
 size(640, 360, P2D); 
 noStroke();

 rave = loadShader("rave.glsl"); 
 rave.set("iResolution", float(width), float(height));
 rave.set("iTime", millis() / 500.0);
 rave.set("iMouse", mouseX, mouseY);

}

void draw() {
 shader(rave);
 rect(0.0, 0.0, width, height);
 rave.set("iTime", millis() / 500.0);
}

void keyPressed() {
  if (key==' ') {
    hf.save("img");
  }
}
