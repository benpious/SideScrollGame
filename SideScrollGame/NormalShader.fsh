//fragment shader for normal mapping

varying lowp vec4 colorVarying;

uniform sampler2D texture;
uniform sampler2D normals;


void main()
{
    //get the cosine of the light and the normals
    
    vec4 textureColor = texture2D(texture, fTextureCoords);
    vec3 normalVec = texture2D(normalTexture, fTextureCoords).rgb;

    float nDotVP = max(0.0, dot(normalVec, normalize(lightPosition)));
    
    gl_FragColor = nDotVP;
}
