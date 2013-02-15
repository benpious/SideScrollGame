uniform sampler2d texture;
uniform sampler2d normals;

varying lowp vec2  GLKVertexAttribTexCoord0;

uniform mat4 modelViewProjectionMatrix;

uniform mat3 normalMatrix;

void main()
{

    vec3 eyeNormal = normalize(normalMatrix * normal);
    vec3 lightPosition = vec3(0.0, 0.0, 1.0);
    vec4 diffuseColor = vec4(0.4, 0.4, 1.0, 1.0);
    
    float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
                 
    
    gl_Position = modelViewProjectionMatrix * position;
}
