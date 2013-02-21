//fragment shader for normal mapping
varying mediump vec2 ftexCoord;

uniform sampler2D texture;
uniform sampler2D normals;
uniform lowp vec3 lightPosition;
lowp vec4 diffuseColor;

void main()
{

    lowp vec4 textureColor = texture2D(texture, ftexCoord);
    
    lowp vec3 normalVec = normalize(texture2D(normals, ftexCoord).rgb * 2.0 - 1.0);
        
    lowp vec3 lightDir = normalize(vec3(lightPosition.xy - gl_FragCoord.xy, lightPosition.z));
    
    lowp vec3 intensity = diffuseColor.rgb * diffuseColor.a;
    
    lowp vec3 illumination =  normalize(intensity * max(0.0, dot(normalVec, lightDir))) + intensity;
    
    lowp vec3 color = textureColor.rgb * illumination;
    
    gl_FragColor = vec4(color, textureColor.a);
    
}
