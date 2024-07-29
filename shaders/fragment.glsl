// export default /*glsl*/ 

uniform float uTime;
uniform vec2 uResolution;
uniform float uDisplace;
uniform float uSpread;
uniform float uNoise;

varying vec3 vNormal;
varying vec3 vPosition;
varying vec2 vUv;


const float PI = 3.14159265359;
#define MOD3 vec3(.1031,.11369,.13787)

vec3 hash33(vec3 p3) {
    p3 = fract(p3 * MOD3);
    p3 += dot(p3, p3.yxz + 19.19);
    return -1.0 + 2.0 * fract(vec3((p3.x + p3.y) * p3.z, (p3.x + p3.z) * p3.y, (p3.y + p3.z) * p3.x));
}

float pnoise(vec3 p) {
    vec3 pi = floor(p);
    vec3 pf = p - pi;
    vec3 w = pf * pf * (3.0 - 2.0 * pf);
    return mix(
        mix(
            mix(dot(pf - vec3(0.0, 0.0, 0.0), hash33(pi + vec3(0.0, 0.0, 0.0))),
                dot(pf - vec3(1.0, 0.0, 0.0), hash33(pi + vec3(1.0, 0.0, 0.0))),
                w.x),
            mix(dot(pf - vec3(0.0, 0.0, 1.0), hash33(pi + vec3(0.0, 0.0, 1.0))),
                dot(pf - vec3(1.0, 0.0, 1.0), hash33(pi + vec3(1.0, 0.0, 1.0))),
                w.x),
            w.z),
        mix(
            mix(dot(pf - vec3(0.0, 1.0, 0.0), hash33(pi + vec3(0.0, 1.0, 0.0))),
                dot(pf - vec3(1.0, 1.0, 0.0), hash33(pi + vec3(1.0, 1.0, 0.0))),
                w.x),
            mix(dot(pf - vec3(0.0, 1.0, 1.0), hash33(pi + vec3(0.0, 1.0, 1.0))),
                dot(pf - vec3(1.0, 1.0, 1.0), hash33(pi + vec3(1.0, 1.0, 1.0))),
                w.x),
            w.z),
        w.y);
}

void main() {
   float pat = pnoise(vec3(vUv * uNoise, sin(uTime) * 1.4)) * uDisplace;
    float proximity = abs(vUv.x - (0.5 + sin(uTime) / (12.0 * uSpread)));
    float noise = pnoise(vec3(vPosition.z * 50.0));
    vec3 full = pat * vec3(clamp(0.23 * uSpread - proximity, 0.0, 1.0));
    vec3 newPosition = vPosition + vNormal * full;
    vec3 purple = vec3(0.498, 0.2039, 0.8314) / vec3(0.4941, 0.4941, 0.051);
    vec3 color = vec3(pnoise(vec3(1.0 - newPosition.z * 35.0)) * 40.0) * (0.01 - full) * purple;
    gl_FragColor = vec4(color, 1.0);
}