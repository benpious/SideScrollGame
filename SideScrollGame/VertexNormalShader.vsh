attribute vec4 position;
attribute vec3 normal;


varying lowp vec2  GLKVertexAttribTexCoord0;
varying lowp vec2  fTextureCoords;

varying lowpvec2  GLKVertexAttribTexCoord1;
varying lowp vec2  fNormalCoords;

uniform mat4 modelViewProjectionMatrix;
uniform mat4 fModelViewProjectionMatrix;
uniform mat3 normalMatrix;

void main()
{
    
    fTextureCoords =  GLKVertexAttribTexCoord0;
    fNormalCoords = GLKVertexAttribTexCoord1;
    fModelViewProjectionMatrix = modelViewProjectionMatrix;
    
    vec3 eyeNormal = normalize(normalMatrix * normal);
    vec3 lightPosition = vec3(0.0, 0.0, 1.0);
    vec4 diffuseColor = vec4(0.4, 0.4, 1.0, 1.0);
    
    float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
                 
    
    gl_Position = modelViewProjectionMatrix * position;
}
