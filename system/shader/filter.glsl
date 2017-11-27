extern vec2 step;
extern vec3 color;
extern mat3 kernel;

vec4 effect(vec4 col, Image texture, vec2 texturePos, vec2 screenPos) {
	number alpha = 0;

	alpha += kernel[0][0] * texture2D( texture, texturePos + vec2( -step.x, -step.y ) ).a;
	alpha += kernel[0][1] * texture2D( texture, texturePos + vec2( 0.0f, -step.y ) ).a; 
	alpha += kernel[0][2] * texture2D( texture, texturePos + vec2( step.x, -step.y ) ).a; 

	alpha += kernel[1][0] * texture2D( texture, texturePos + vec2( -step.x, 0.0f ) ).a;
	alpha += kernel[1][1] * texture2D( texture, texturePos + vec2( 0.0f, 0.0f ) ).a; 
	alpha += kernel[1][2] * texture2D( texture, texturePos + vec2( step.x, 0.0f ) ).a;  
	
	alpha += kernel[2][0] * texture2D( texture, texturePos + vec2( -step.x, step.y ) ).a;
	alpha += kernel[2][1] * texture2D( texture, texturePos + vec2( 0.0f, step.y ) ).a; 
	alpha += kernel[2][2] * texture2D( texture, texturePos + vec2( step.x, step.y ) ).a; 

	return vec4( color.x, color.y, color.z, alpha );
}