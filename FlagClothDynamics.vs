#version 430 core

uniform mat4 viewTransform;
uniform mat4 projTransform;
uniform mat4 modelTransform;
uniform vec3 cameraPosition;
uniform float time;

layout(location = 0) in vec3 modelPosition;
layout(location = 1) in vec3 vertexNormal;
layout(location = 2) in vec2 uv;

out VS_OUT
{
	vec3 vertex;
	vec3 vertexNormal;
	vec2 uv;
} vs_out;

out gl_PerVertex {
	vec4 gl_Position;
};

vec2 modAmplitudeFactor = vec2(0.075, 0.075);
vec2 vtxModOffset = vec2(1,1);
vec2 rippleDensity = vec2(7,2);
vec2 rippleSpeed = vec2(4,2);
vec2 xyOffsetAmplitude = vec2(0.15, 0.1);

void main()
{
	//Input mesh is a normalized 2d plane along the x-y axis
    vec3 vertex = modelPosition;
	float xOffset = (vertex.x + vtxModOffset.x) * modAmplitudeFactor.x * sin(rippleDensity.x*vertex.x + rippleSpeed.x*time);
	float yOffset = (vertex.x + vtxModOffset.y) * modAmplitudeFactor.y * sin(rippleDensity.y*vertex.y + rippleSpeed.y*time);
	
	vertex.z = vertex.z 
	+ xOffset
	+ yOffset;
	
	vertex.x = vertex.x + xyOffsetAmplitude.x * yOffset;
	vertex.y = vertex.y + xyOffsetAmplitude.y * xOffset;
	
	vs_out.vertex = vertex;
	
	//MVP should be concatenated CPU side but whatever...
    gl_Position = projTransform * viewTransform * modelTransform * (vec4(vertex, 1.0f));
    vs_out.vertexNormal = vertexNormal;
	vs_out.uv = vec2(modelPosition.x, modelPosition.y);
}
