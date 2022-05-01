PShader deformed;

HelperFunctions hf = new HelperFunctions();

void setup() {
 size(640, 360, P2D); 
 noStroke();

 deformed = loadShader("deformed.glsl"); 
 deformed.set("iResolution", float(width), float(height));
 deformed.set("iTime", millis() / 500.0);
 deformed.set("iMouse", mouseX, mouseY);

}

void draw() {
 shader(deformed);
 rect(0.0, 0.0, width, height);
 deformed.set("iTime", millis() / 500.0);
}

void keyPressed() {
  if (key==' ') {
    hf.save("img");
  }
}
