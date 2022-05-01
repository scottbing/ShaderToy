PShader tunnel;
PImage img0;
PImage img1;

HelperFunctions hf = new HelperFunctions();

void setup() {
 size(640, 360, P2D); 
 noStroke();
 ((PGraphics2D)g).textureWrap(Texture.REPEAT);   
 img0 = loadImage("Channel0.png");
 img1 = loadImage("Channel1.png");
  
 tunnel = loadShader("tunnel.glsl"); 
 tunnel.set("iResolution", float(width), float(height));
 tunnel.set("time", millis() / 500.0);
 tunnel.set("iChannel0", img0);
 tunnel.set("iChannel1", img1);

}

void draw() {
 shader(tunnel);
 rect(0.0, 0.0, width, height);
 tunnel.set("time", millis() / 500.0);
}

void keyPressed() {
  if (key==' ') {
    hf.save("img");
  }
}
