#version 420

uniform vec3 in_colour;

layout (location = 0) out vec4 out_colour;

void main()
{
    out_colour = vec4(in_colour * (1.0f-gl_FragCoord.z)*30f, 1.0f);
}
