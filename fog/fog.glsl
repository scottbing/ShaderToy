//Heavy performance impact 
#define AA 1
#define raymarchSteps 30
#define rotationSpeed 7.
#define ZERO min(iFrame, 0)
#define post
#define vignet

uniform vec2 iResolution;
uniform float iTime;
uniform int iFrame;

const float pi = 3.14159265359;
mat2 rot(float a){
    float c = cos(a);
    float s = sin(a);
    return mat2(c,-s,s,c);
}
// Base primitive
float sdBox( vec3 p, vec3 b )
{
    vec3 q = abs(p) - b;
    return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

vec4 map(vec3 p) {
    mat2 rotx = rot(sin (2. * iTime*0.1)*pi + sin(pi * iTime*0.1)*pi);
    mat2 rotz = rot(cos(iTime/4.)*pi);
    mat2 roty = rot(sin(iTime/4.+12313.123)*pi);
    int maxI = 8;
    float scale = 1.;
    const float factor = 2.;
    const float baseSize = .7;
    float d = 10e10;
    for (int i=ZERO;i<maxI;i++){ 
        p = abs(p)-.4*factor;
        p *= factor;
        scale /= factor;
        p.yz *= rotx;
        p.xy *= rotz;
        p.xz *= roty;

    }
            d = min(d,
             sdBox(p-vec3(0,.44*factor,0), (vec3(baseSize)))*scale-(0.4*scale)
             );
    return vec4(d,p);
}

float intersection(vec3 ro, vec3 rd){
    float T = 0.;
    for(int i=0;i < raymarchSteps;i++){
        float dist = map(ro+rd*T).x;
        
        T +=dist;
        if(dist <0.0026*T || dist > 4.)
            break;
    }
    return T;
}

//iq ---
float softshadow( in vec3 ro, in vec3 rd, float mint, float maxt, float k , float d){
    float res = 1.0;
    for( float t=mint; t<maxt; )
    {
        float h = map(ro + rd*t).x;
        if( h<0.0005*d )
            return 0.0;
        res = min( res, k*h/t );
        t += h;
    }
    return res;
}
vec3 calcNormal( in vec3 p, float t ){
    float h = 0.002*t;
    vec3 n = vec3(0.0);
    for( int i=ZERO; i<4; i++ )
    {
        vec3 e = 0.5773*(2.0*vec3((((i+3)>>1)&1),((i>>1)&1),(i&1))-1.0);
        n += e*map(p+e*h).x;
    }
    return normalize(n);
}
float calcAO(vec3 pos, vec3 nor){
	float occ = 0.0;
    float sca = .4;
    for( int i=ZERO; i<5; i++ )
    {
            float h = 0.01 + 0.25*float(i)/4.0;
        float d = map( pos+h*nor).x;
        occ += (h-d)*sca;
        sca *= 0.95;
    }
    return clamp( 1.0 - 3.0*occ, 0.0, 1.0 );
}
// ---
vec4 render(vec3 ro, vec3 rd){
    //world info
    float dist = clamp(0.,10.,intersection(ro,rd));
    vec3 pos = dist*rd+ro;
    vec4 d_t = map(pos);
    vec3 trp = d_t.yzw;
   float dis = d_t.x;
   float trd = distance(pos, trp);
    //Shading
     vec3 sun = normalize(vec3(1., 1., 1.1));
    float sha = softshadow(pos, sun, 0.01, 5., 4., dist);
     vec3 nor = calcNormal(pos,dist);
    float occ = calcAO(pos, nor);
    float lig = (dot(sun,nor)*0.5+0.5);

    //Colors
    vec3 col = vec3(0);
    vec3 bcl = 0.8*vec3(log(trd),0.5,cos(trd))*vec3(1,2,2);
    vec3 scl = vec3(0.933,0.918,0.827);
    vec3 amb = vec3(0.949,0.702,1.000);
    vec3 ref = reflect(rd,nor);
    
    vec3 hvc = normalize(sun - rd);
    //Intergral fog
    float fogAmount;
    {
        float a = rd.y*0.0125;
        float h = ro.y-2.5;
        float fogDist = length(rd.xy)*dist;
        fogAmount = (exp(fogDist*a)-1.)*exp(-fogDist*a-h)/a;
    }
    //Sun fog
    float sunFog;
    {
        float a = sun.y*0.0125;
        float h = pos.y-2.5;
        float fogDist = length(sun.xy)*1000.;
        sunFog = (exp(fogDist*a)-1.)*exp(-fogDist*a-h)/a;
    }
    float sunOcc = exp(-sunFog*0.0003);
    
    if (dis < 0.1) {
        col += 4.*lig*sha*bcl*scl*sunOcc;
        col += .2*amb*occ*bcl*(abs(dot(nor,sun))*.5+.5)*sunOcc;
        col += .2*occ*(dot(ref, rd)+1.);
        col += amb*pow(dot(nor,hvc)*.5+.5, 5.)*sha;
        col += occ*2.*vec3(0.757,0.486,0.024)*bcl*scl*(.75+0.25*dot(nor,-sun))/smoothstep(-2.0,2.,length(pos.xz))*sunOcc;
    } else {
        fogAmount = 1.;
    }
    
    col = mix(col,amb,clamp(fogAmount , 0., 1.));
        
        
    col += vec3(0.949,0.824,0.553)*smoothstep(-.2,.5,dot(rd,sun));
    return vec4(col, 1);
}
void mainImage( out vec4 fragColor, in vec2 fragCoord ) {

    vec3   ro = vec3(0, 0, -5.5);
    mat2 yrot = rot(iTime*0.2);
    mat2 xrot = rot(.9);
           ro.yz *= xrot;
           ro.xz *= yrot;

    vec4 tot = vec4(0);
    
    //Super sampling
    for(int m=0;m<AA;m++){
    for(int n=0;n<AA;n++){
        vec2 o = vec2(float(m),float(n)) / float(AA) - 0.5;
        vec2 u = ((fragCoord+o) / iResolution.xy - 0.5) / vec2(iResolution.y / iResolution.x, 1);
        vec3 rd = normalize(vec3(u, 1));
        rd.yz *= xrot;
        rd.xz *= yrot;
        tot += render(ro, rd) / float(AA*AA);
    }}

    
    #ifdef vignet
    vec2 uv = fragCoord/iResolution.xy-0.5;
    tot *= smoothstep(1.34, 0., length(uv));
    #endif
    
    // Output to screen
    #ifdef post
    fragColor = sqrt(smoothstep(.0,1.6,tot));
    #else
    fragColor = tot;
    #endif
}

void main() {
    mainImage(gl_FragColor, gl_FragCoord.xy);
}