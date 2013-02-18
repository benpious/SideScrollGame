//fragment shader for normal mapping
varying mediump vec2 ftexCoord;

uniform sampler2D texture;
uniform sampler2D normals;


void main()
{
    //get the cosine of the light and the normals
    
    lowp vec4 textureColor = texture2D(texture, ftexCoord);
    lowp vec3 normalVec = texture2D(normals, ftexCoord).rgb;
    
    gl_FragColor = textureColor;
}
