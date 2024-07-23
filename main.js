import * as THREE from 'three';
import { OrbitControls } from "https://esm.sh/three/examples/jsm/controls/OrbitControls";
import { EffectComposer } from "https://esm.sh/three/examples/jsm/postprocessing/EffectComposer";
import { RenderPass } from "https://esm.sh/three/examples/jsm/postprocessing/RenderPass";
import { UnrealBloomPass } from "https://esm.sh/three/examples/jsm/postprocessing/UnrealBloomPass";
import vertex from "./shaders/vertex.glsl";
import fragment from "./shaders/fragment.glsl";

// Scene, Camera, and Renderer
const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
camera.position.z = 5;

const renderer = new THREE.WebGLRenderer();
renderer.setSize(window.innerWidth, window.innerHeight);
document.body.appendChild(renderer.domElement);

// OrbitControls
const controls = new OrbitControls(camera, renderer.domElement);
controls.enableDamping = true;

// Geometry and ShaderMaterial
const geometry = new THREE.TorusGeometry(1, 0.4, 1000, 1000);
const material = new THREE.ShaderMaterial({
    vertexShader: vertex,
    fragmentShader: fragment,
    uniforms: {
      uTime: { value: 0.0 }, // Initialize the uniform
      uMouse: { value: new THREE.Vector2(0.5, 0.5) } // Initialize mouse uniform
  }
});

const torus = new THREE.Mesh(geometry, material);
scene.add(torus);

// EffectComposer Setup
const composer = new EffectComposer(renderer);
const renderPass = new RenderPass(scene, camera);
composer.addPass(renderPass);

// Adjusted BloomPass
const bloomPass = new UnrealBloomPass(new THREE.Vector2(window.innerWidth, window.innerHeight), 0.5, 0.1, 0.4);
composer.addPass(bloomPass);

const clock = new THREE.Clock();

// Animation Loop
const animate = function () {
    requestAnimationFrame(animate);

    // Update the uniform value with the elapsed time
    // material.uniforms.uTime.value += 0.05; // Adjust animation speed as needed
    const elapsedTime = clock.getElapsedTime();
    torus.material.uniforms.uTime.value = elapsedTime;
    torus.rotation.z = Math.sin(elapsedTime) / 4 + elapsedTime / 20 + 5;

    controls.update();
    composer.render(); // Render with composer
};


animate();

// Handle Window Resize
window.addEventListener('mousemove', (event) => {
  // Normalize mouse coordinates
  const mouseX = (event.clientX / window.innerWidth) * 2 - 1;
  const mouseY = -(event.clientY / window.innerHeight) * 2 + 1;
  material.uniforms.uMouse.value.set(mouseX, mouseY);
});


window.addEventListener('resize', () => {
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();
  renderer.setSize(window.innerWidth, window.innerHeight);
  composer.setSize(window.innerWidth, window.innerHeight); // Update composer size
});
