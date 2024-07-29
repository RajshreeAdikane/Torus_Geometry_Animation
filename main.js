import * as THREE from 'three';
import { OrbitControls } from "https://esm.sh/three/examples/jsm/controls/OrbitControls";
import { EffectComposer } from "https://esm.sh/three/examples/jsm/postprocessing/EffectComposer";
import { RenderPass } from "https://esm.sh/three/examples/jsm/postprocessing/RenderPass";
import { UnrealBloomPass } from "https://esm.sh/three/examples/jsm/postprocessing/UnrealBloomPass";
import vertex from "./shaders/vertex.glsl";
import fragment from "./shaders/fragment.glsl";
import { GUI } from 'dat.gui';

const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
camera.position.z = 5;

const renderer = new THREE.WebGLRenderer();
renderer.setSize(window.innerWidth, window.innerHeight);
document.body.appendChild(renderer.domElement);

const controls = new OrbitControls(camera, renderer.domElement);
controls.enableDamping = true;

const geometry = new THREE.TorusGeometry(1, 0.4, 1000, 1000);
const material = new THREE.ShaderMaterial({
    vertexShader: vertex,
    fragmentShader: fragment,
    side: THREE.DoubleSide,
    uniforms: {
        uTime: { value: 0 },
        uResolution: { value: new THREE.Vector2(window.innerWidth, window.innerHeight) },
        uDisplace: { value: 0.2 },
        uSpread: { value: 0.5 },
        uNoise: { value: 10.0 },
    },
    glslVersion: THREE.GLSL460,
});

const torus = new THREE.Mesh(geometry, material);
scene.add(torus);

const composer = new EffectComposer(renderer);
const renderPass = new RenderPass(scene, camera);
composer.addPass(renderPass);

const bloomPass = new UnrealBloomPass(new THREE.Vector2(window.innerWidth, window.innerHeight), 1.4, 0.0001, 0.01);
composer.addPass(bloomPass);

const clock = new THREE.Clock();

const gui = new GUI();

gui.add(torus.material.uniforms.uDisplace, 'value', 0, 2, 0.1).name('displacemnt');
gui.add(torus.material.uniforms.uSpread, 'value', 0, 2, 0.1).name('spread');
gui.add(torus.material.uniforms.uNoise, 'value', 10, 25, 0.1).name('noise');


const animate = function () {
    requestAnimationFrame(animate);
    const elapsedTime = clock.getElapsedTime();
    torus.material.uniforms.uTime.value = elapsedTime;
    torus.rotation.z = Math.sin(elapsedTime) / 4 + elapsedTime / 20 + 5;

    controls.update();
    composer.render();
};


animate();
window.addEventListener('resize', () => {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
    composer.setSize(window.innerWidth, window.innerHeight);
});
