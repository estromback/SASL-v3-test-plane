#version 120 

uniform float testParameter;

uniform float testTextureWidth;
uniform float testTextureHeight;
uniform sampler2D testTexture;

uniform float testArray1[16];
uniform float testArray2[9];

float randomF(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main(void)
{
	vec2 pos = vec2(gl_FragCoord.x / testTextureWidth + testParameter, gl_FragCoord.y / testTextureHeight + testParameter);
	vec4 texColor = texture2D(testTexture, pos);
	texColor.g = texColor.r * randomF(pos);
	
	texColor.b *= testArray1[3] * testArray1[5] * testArray2[2] * testArray2[8];
	
	gl_FragColor = vec4(0.2 * texColor.r, 1.0 * texColor.g, testParameter * texColor.b, 1.0 * texColor.a);
}