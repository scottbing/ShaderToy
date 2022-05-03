PShader structure;
PImage img0;
PImage img1;
PImage img2;
PImage img3;

HelperFunctions hf = new HelperFunctions();

void setup() {
 size(640, 360, P2D); 
 noStroke();
 ((PGraphics2D)g).textureWrap(Texture.REPEAT);   
 img0 = loadImage("iChannel0.png");
 img1 = loadImage("iChannel1.png");
 img2 = loadImage("iChannel2.png");
 img3 = loadImage("iChannel3.png");
  
 structure = loadShader("structure.glsl"); 
 structure.set("iResolution", float(width), float(height));
 structure.set("iTime", millis() / 500.0);
 structure.set("iChannel0", img0);
 structure.set("iChannel1", img1);
 structure.set("iChannel0", img2);
 structure.set("iChannel1", img3);


}

void draw() {
 shader(structure);
 rect(0.0, 0.0, width, height);
 structure.set("iTime", millis() / 500.0);
}

void keyPressed() {
  if (key==' ') {
    hf.save("img");
  }
}
