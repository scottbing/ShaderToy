// set up the matrices
mat4 translate(vec3 p) {
    return mat4(1.0,  0.0,  0.0,  -p.x,
              0.0,  1.0,  0.0,  -p.y,
              0.0,  0.0,  1.0,  -p.z,
              0.0, 0.0, 0.0, 1.0);
}

mat4 scale(vec3 s) {
    return mat4(s.x,  0.0,  0.0,  0.0,
              0.0,  s.y,  0.0,  0.0,
              0.0,  0.0,  s.z,  0.0,
              0.0, 0.0, 0.0, 1.0);
}

mat4 rotateZ(float theta) {
    float c = cos(theta);
    float s = sin(theta);
    return mat4(c,  -s,  0.0,  0.0,
              s,  c,  0.0,  0.0,
              0.0,  0.0,  1.0,  0.0,
              0.0, 0.0, 0.0, 1.0);
}

mat4 rotateY(float theta) {
    float c = cos(theta);
    float s = sin(theta);
    return mat4(c,  0.0, s,  0.0,
              0.0,  1.0, 0.0, 0.0,
              -s,  0.0, c,  0.0,
              0.0, 0.0, 0.0, 1.0);
}

mat4 rotateX(float theta) {
    float c = cos(theta);
    float s = sin(theta);
    return mat4(1.0, 0.0, 0.0, 0.0,
                0.0, c,  -s,  0.0, 
                0.0, s,  c,  0.0,
                0.0,  0.0,  0.0,  1.0);
}

uniform vec2 iResolution;
uniform float iTime;
uniform vec4 iMouse;

float g(vec3 x) {
    return max(x.z,max(-x.z,max(x.y,max(-x.y,max(x.x, -x.x)))))-1.0;
}

float h(vec3 x) {
    mat4 m = rotateZ(1.5*iTime-3.128)*scale(vec3(1.0, 1.0, 1.0));
    return g((vec4(x, 1.0)*m).xyz);
}

vec2 xy;

float f(vec3 x) {
    mat4 m = translate(vec3(1.4, -0.71+0.0*xy.y, 0.1+0.0*xy.x))*rotateY(5.123+0.01*iTime)
        *scale(vec3(1.02, 1.01, 1.01))*rotateZ(-0.125+0.075*iTime);
    float norm = 1.02;
    float s = 1.0;
    float t = 1000.0;
    for (int i = 0; i < 10; ++i) {
        x.x = abs(x.x);
        float hh = h(x)/s;
        t = min(t, hh);
        x = (vec4(x, 1.0)*m).xyz;
        s *= norm;
    }
    return t;
}

float eps = 0.0001;
float lambda = 2.0;

vec3 ico[12];

//vec3 hash3(vec3 x) {
//    float u = 1000.0*sin(x.x*x.y+3.3*x.z-2.2*x.y+10.123*x.y+11.12*x.y*x.z);
//    float v = 1000.0*sin(x.z*x.y-2.1*x.z+3.0*x.z+7.211*x.y+32.12*x.y*x.x);
//    float w = 1000.0*cos(x.z*x.y+3.4*x.z-3.0*x.x+17.97*x.y+11.12*x.x*x.y);
//    return vec3(u-floor(u), v-floor(v), w-floor(w));
//}

float lighting(vec3 x, vec3 n) {
    float t = 0.0;
    for (int i = 0; i < 12; ++i) {
        t += f(x+0.5*n+0.25*ico[i]);
    }
    return t/12.0;
}

vec3 march(vec3 p, vec3 d) {
    float c;
    c = f(p);
    if (c < 0.0) {
        return vec3(0.0, 0.0, 0.0);
    }
    for (int i = 0; i < 70; ++i) {
        float step = max(0.02, c);
        p = p+step*d;
        c = f(p);
        if (c <= 0.0) {
            float ex, ey, ez;
            ex = f(p+vec3(eps, 0.0, 0.0));
            ey = f(p+vec3(0.0, eps, 0.0));
            ez = f(p+vec3(0.0, 0.0, eps));
            vec3 n = vec3(ex-c, ey-c, ez-c)/eps;
            n = normalize(n);
            mat4 m = rotateY(0.1*iTime);
            vec3 light = (vec4(1.0,1.0,-1.0,1.0)*m).xyz;
            float l = 0.0;
            l += 0.1+0.4*max(dot(n, light)/sqrt(3.0), 0.0);
            l += 1.0*lighting(p, n);
            return vec3(l)*vec3(0.7, 0.7, 0.7);
        }
    }
    return vec3(0.1, 0.1, 0.1);
}

void mainImage(out vec4 gl_FragColor, in vec2 fragCoord) {
    

ico[0]=    vec3(-0.26286500, 0.0000000, 0.42532500);
ico[1]=    vec3(0.26286500, 0.0000000, 0.42532500);
ico[2]=    vec3(-0.26286500, 0.0000000, -0.42532500);
ico[3]=    vec3(0.26286500, 0.0000000, -0.42532500);
ico[4]=    vec3(0.0000000, 0.42532500, 0.26286500);
ico[5]=    vec3(0.0000000, 0.42532500, -0.26286500);
ico[6]=    vec3(0.0000000, -0.42532500, 0.26286500);
ico[7]=    vec3(0.0000000, -0.42532500, -0.26286500);
ico[8]=    vec3(0.42532500, 0.26286500, 0.0000000);
ico[9]=    vec3(-0.42532500, 0.26286500, 0.0000000);
ico[10]=    vec3(0.42532500, -0.26286500, 0.0000000);
ico[11]=    vec3(-0.42532500, -0.26286500, 0.0000000);    
    
    vec2 uv = fragCoord.xy-0.5*iResolution.xy;
    uv = 2.0*uv/iResolution.y;
    xy = iMouse.xy/iResolution.xy;

    vec3 p = vec3(0.0, 0.0, -12.0)+0.1*vec3(xy.x, xy.y, 0.0);;
    vec3 d = normalize(vec3(0.5*uv, 1.0));
    mat4 m = rotateY(0.1*iTime-6.28*xy.x);
    p = (vec4(p, 1.0)*m).xyz;
    d = (vec4(d, 1.0)*m).xyz;
    vec3 color = march(p, d);
    gl_FragColor = vec4(color, 1.0);
}

void main() {
    mainImage(gl_FragColor, gl_FragCoord.xy);
}
