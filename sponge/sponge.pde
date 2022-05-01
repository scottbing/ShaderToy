PShader sponge;

HelperFunctions hf = new HelperFunctions();

void setup() {
 size(640, 360, P2D); 
 noStroke();

 sponge = loadShader("sponge.glsl"); 
 sponge.set("iResolution", float(width), float(height));
 sponge.set("iTime", millis() / 500.0);

}

void draw() {
 shader(sponge);
 rect(0.0, 0.0, width, height);
 sponge.set("iTime", millis() / 500.0);
}

void keyPressed() {
  if (key==' ') {
    hf.save("img");
  }
}
