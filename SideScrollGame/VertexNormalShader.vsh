uniform sampler2D texture;
uniform sampler2D normals;
attribute vec2 texCoord;
varying vec2 ftexCoord;

uniform mat4 modelViewProjectionMatrix;

uniform mat3 normalMatrix;
attribute vec4 position;

void main()
{

    //vec3 eyeNormal = normalize(normalMatrix * normal);
    vec3 lightPosition = vec3(0.0, 0.0, 1.0);
    vec4 diffuseColor = vec4(0.4, 0.4, 1.0, 1.0);
    
    //float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
    
    ftexCoord = texCoord;

    gl_Position = modelViewProjectionMatrix * position;


}
