uniform sampler2D texture;
uniform sampler2D normals;
attribute vec2 texCoord;
varying vec2 ftexCoord;

uniform mat4 modelViewProjectionMatrix;

uniform vec3 lightPosition;
attribute vec4 position;
uniform vec4 diffuseColor;
uniform vec4 lightColor;
uniform lowp vec3 falloff;
void main()
{

    ftexCoord = texCoord;
    gl_Position = modelViewProjectionMatrix * position;

}
