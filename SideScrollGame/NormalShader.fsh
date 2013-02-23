//fragment shader for normal mapping
varying mediump vec2 ftexCoord;
uniform sampler2D texture;
uniform sampler2D normals;
uniform lowp vec3 lightPosition;
uniform lowp vec4 diffuseColor;
uniform lowp vec3 falloff;
uniform lowp vec4 lightColor;
uniform lowp vec2 resolution;

void main()
{


    lowp vec4 textureColor = texture2D(texture, ftexCoord);
    
    lowp vec3 normalVec = texture2D(normals, ftexCoord).rgb;
    normalVec.g = 1.0 - normalVec.g;
    normalVec = normalize(normalVec * 2.0 -1.0);
        
    lowp vec3 lightDir = vec3(lightPosition.xy - (gl_FragCoord.xy/resolution.xy), lightPosition.z);
    lightDir.x *= resolution.x/resolution.y;
    lowp float depth = length(lightDir);

    lightDir = normalize(lightDir);
        

    lowp float attenuation = 1.0 / (falloff.x + (falloff.y*depth) + (falloff.z*depth*depth));

    lowp vec3 illumination = (lightColor.rgb * lightColor.a) * max(0.0, dot(normalVec, lightDir)) + attenuation + (diffuseColor.rgb * diffuseColor.a);
    
    lowp vec3 color = textureColor.rgb * illumination;
    
    gl_FragColor = vec4(color, textureColor.a);
}
