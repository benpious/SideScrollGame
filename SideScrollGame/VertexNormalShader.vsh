uniform sampler2D texture;
uniform sampler2D normals;
attribute vec2 texCoord;
varying vec2 ftexCoord;

uniform mat4 modelViewProjectionMatrix;

uniform vec3 lightPosition;
uniform mat3 normalMatrix;
attribute vec4 position;
uniform vec4 diffuseColor;

void main()
{

    vec3 lightPosition = vec3(0.0, 0.0, 1.0);
    vec4 diffuseColor = vec4(0.65, 0.65, 0.65, 1.0);
        
    ftexCoord = texCoord;

    gl_Position = modelViewProjectionMatrix * position;

}
