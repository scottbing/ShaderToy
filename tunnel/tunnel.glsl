#define PROCESSING_COLOR_SHADER

uniform vec2 iResolution;
uniform float time;
uniform sampler2D iChannel0;
uniform sampler2D iChannel1;

void mainImage( out vec4 gl_FragColor, in vec2 gl_FragCoord )
{
    vec2 p = gl_FragCoord.xy / iResolution.xy;
    vec2 q = p - vec2(0.5, 0.5);

    q.x += sin(time* 0.6) * 0.2;
    q.y += cos(time* 0.4) * 0.3;

    float len = length(q);

    float a = atan(q.y, q.x) + time * 0.3;
    float b = atan(q.y, q.x) + time * 0.3;
    float r1 = 0.3 / len + time * 0.5;
    float r2 = 0.2 / len + time * 0.5;

    float m = (1.0 + sin(time * 0.5)) / 2.0;
    vec4 tex1 = texture2D(iChannel0, vec2(a + 0.1 / len, r1 ));
    vec4 tex2 = texture2D(iChannel1, vec2(b + 0.1 / len, r2 ));
    vec3 col = vec3(mix(tex1, tex2, m));
    gl_FragColor = vec4(col * len * 1.5, 1.0);
}

void main() {
    mainImage(gl_FragColor, gl_FragCoord.xy);
}

