//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform int type;

void main()
{
	// Change color and texture based on note types
    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
}
