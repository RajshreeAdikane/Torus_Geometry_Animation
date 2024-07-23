uniform float uTime;

varying vec3 vNormal;
varying vec3 vPosition;
varying vec2 vUv;
varying vec3 vPattern;

// Constants
const float PI = 3.14159265359;

// Hash function
vec3 hash33(vec3 p3) {
    p3 = fract(p3 * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.xxy + p3.yzz) * p3.zyx);
}

// Perlin noise function
float pnoise(vec3 P) {
    vec3 Pi = floor(P);
    vec3 Pf = fract(P);
    vec3 Pf_min = Pf - vec3(1.0);

    vec3 hash_x0 = hash33(Pi);
    vec3 hash_x1 = hash33(Pi + vec3(1.0, 0.0, 0.0));
    vec3 hash_y0 = hash33(Pi + vec3(0.0, 1.0, 0.0));
    vec3 hash_y1 = hash33(Pi + vec3(1.0, 1.0, 0.0));
    vec3 hash_z0 = hash33(Pi + vec3(0.0, 0.0, 1.0));
    vec3 hash_z1 = hash33(Pi + vec3(1.0, 0.0, 1.0));
    
    vec3 hash_yz0 = hash33(Pi + vec3(0.0, 1.0, 1.0));
    vec3 hash_yz1 = hash33(Pi + vec3(1.0, 1.0, 1.0));
    
    vec3 g000 = hash_x0;
    vec3 g100 = hash_x1;
    vec3 g010 = hash_y0;
    vec3 g110 = hash_y1;
    vec3 g001 = hash_z0;
    vec3 g101 = hash_z1;
    vec3 g011 = hash_yz0;
    vec3 g111 = hash_yz1;
    
    float n000 = dot(g000, Pf);
    float n100 = dot(g100, vec3(Pf.x - 1.0, Pf.y, Pf.z));
    float n010 = dot(g010, vec3(Pf.x, Pf.y - 1.0, Pf.z));
    float n110 = dot(g110, vec3(Pf.x - 1.0, Pf.y - 1.0, Pf.z));
    float n001 = dot(g001, vec3(Pf.x, Pf.y, Pf.z - 1.0));
    float n101 = dot(g101, vec3(Pf.x - 1.0, Pf.y, Pf.z - 1.0));
    float n011 = dot(g011, vec3(Pf.x, Pf.y - 1.0, Pf.z - 1.0));
    float n111 = dot(g111, vec3(Pf.x - 1.0, Pf.y - 1.0, Pf.z - 1.0));
    
    vec3 fade_xyz = Pf * Pf * Pf * (Pf * (Pf * 6.0 - 15.0) + 10.0);
    float n_z0 = mix(n000, n100, fade_xyz.x);
    float n_z1 = mix(n010, n110, fade_xyz.x);
    float n_y0 = mix(n_z0, n_z1, fade_xyz.y);
    
    n_z0 = mix(n001, n101, fade_xyz.x);
    n_z1 = mix(n011, n111, fade_xyz.x);
    float n_y1 = mix(n_z0, n_z1, fade_xyz.y);
    
    float n = mix(n_y0, n_y1, fade_xyz.z);
    return 2.2 * n;
}

void main() {
    vNormal = normalize(normalMatrix * normal);
    vPosition = (modelMatrix * vec4(position, 1.0)).xyz;
    vUv = uv;

    float noiseMultiplier = clamp((abs(vUv.x - 0.5) - 0.3) * 3.0, 0.0, 1.0);
    vPattern = vec3 (noiseMultiplier);
    float noise = pnoise(vPosition * 5.0 + vec3(uTime));
    float displacement = noise * noiseMultiplier;

    vec3 newPosition = vPosition + vNormal * displacement;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(newPosition, 1.0);
}
