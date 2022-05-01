PShader canyon;
PImage img0;
PImage img1;

HelperFunctions hf = new HelperFunctions();

void setup() {
 size(640, 360, P2D); 
 noStroke();
 ((PGraphics2D)g).textureWrap(Texture.REPEAT);   
 img0 = loadImage("iChannel0.png");
 img1 = loadImage("iChannel1.png");
  
 canyon = loadShader("canyon.glsl"); 
 canyon.set("iResolution", float(width), float(height));
 canyon.set("iTime", millis() / 500.0);
 canyon.set("iChannel0", img0);
 canyon.set("iChannel1", img1);

}

void draw() {
 shader(canyon);
 rect(0.0, 0.0, width, height);
 canyon.set("iTime", millis() / 500.0);
}

void keyPressed() {
  if (key==' ') {
    hf.save("img");
  }
}
