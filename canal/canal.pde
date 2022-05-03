PShader canal;
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
  
 canal = loadShader("canal.glsl"); 
 canal.set("iResolution", float(width), float(height));
 canal.set("iTime", millis() / 500.0);
 canal.set("iChannel0", img0);
 canal.set("iChannel1", img1);
 canal.set("iChannel0", img2);
 canal.set("iChannel1", img3);


}

void draw() {
 shader(canal);
 rect(0.0, 0.0, width, height);
 canal.set("iTime", millis() / 500.0);
}

void keyPressed() {
  if (key==' ') {
    hf.save("img");
  }
}
