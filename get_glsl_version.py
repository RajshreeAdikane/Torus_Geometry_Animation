import pygame
from OpenGL.GL import glGetString, GL_SHADING_LANGUAGE_VERSION

# Initialize Pygame
pygame.init()

# Create an OpenGL context
display = (800, 600)
pygame.display.set_mode(display, pygame.OPENGL | pygame.DOUBLEBUF)

# Print the GLSL version
glsl_version = glGetString(GL_SHADING_LANGUAGE_VERSION)
print(f"GLSL Version: {glsl_version.decode('utf-8')}")

# Quit Pygame
pygame.quit()
