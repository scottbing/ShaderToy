PShader fog;

HelperFunctions hf = new HelperFunctions();

void setup() {
 size(640, 360, P2D); 
 noStroke();

 fog = loadShader("fog.glsl"); 
 fog.set("iResolution", float(width), float(height));
 fog.set("iTime", millis() / 500.0);
 fog.set("iFrame",0);

}

void draw() {
 shader(fog);
 rect(0.0, 0.0, width, height);
 fog.set("iTime", millis() / 500.0);
}

void keyPressed() {
  if (key==' ') {
    hf.save("img");
  }
}
