Shader "Caustics/VoronoiDiagramSurf"
{
	Properties
	{
		_Radius("Radius", Range(0,0.25)) = 0.23
		_P("P", Range(1,2)) = 2
		_Size("Plane Size", Vector) = (0.0, 0.0, 0.0, 0.0)
		_Color("Color", Color) = (1, 1, 1, 1)
		_Cube("Cubemap", CUBE) = "" {}
		_Distortion("Distortion", 2D) = "" {}
		_Metallic("Metallic", Range(0, 1)) = 1
		_Smoothness("Smoothness", Range(0, 1)) = 1
		_Alpha("Alpha", Range(0, 1)) = 1
	}

	SubShader
	{
		Tags {"RenderType" = "Transparent" "Queue" = "Transparent"}
		LOD 200
		Pass{
			ColorMask 0
		}

		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite Off
		ColorMask RGB
		
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:fade

		uniform half _P;
		uniform half _Radius;
		uniform int _Length = 0;
		uniform fixed2 _Points[200];
		uniform fixed2 _Size;
		uniform float noise;

		sampler2D _MainTex;
		sampler2D _Distortion;
		samplerCUBE _Cube;
		float4 _Color;
		float _Metallic;
		float _Smoothness;
		float4 _EmissionColor;
		float _Alpha;

		struct Input {
			float2 uv_MainTex;
			float3 worldRefl;
			float3 worldPos;
			float2 uv_Distortion;
			half2 uv : TEXCOORD0;
		};

		//Customize cell shape using different distance functions	
		half distance_manhattan(float2 a, float2 b)
		{
			return abs(a.x - b.x) + abs(a.y - b.y);
		}
		half distance_chebyshev(float2 a, float2 b)
		{
			return max(abs(a.x - b.x) , abs(a.y - b.y)	);
		}
		half distance_minkowski(float2 a, float2 b)
		{
			return pow(pow(abs(a.x - b.x),_P) + pow(abs(a.y - b.y),_P),1/_P);
		}
		half distance_euclidean(float2 a, float2 b) {
			return sqrt((a.x-b.x)*(a.x-b.x) + (a.y-b.y)*(a.y-b.y));
		}

		void surf(Input IN, inout SurfaceOutputStandard o) {

			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			float3 distortion = tex2D(_Distortion, IN.uv_Distortion);

			//Calculate voronoi cells
			half minDist = 100000;
			half dist = 0;
			for (int i = 0; i < _Length; i++)
			{
				half dist = distance_minkowski(IN.worldPos.xy, _Points[i].xy * _Size.xy);
				if (dist < minDist)
				{
					minDist = dist;
				}
			}

			//Brightness
			float whiteness = 0.75*log(minDist+1);
			c.rgb = c.rgb + float3(whiteness, whiteness, whiteness);

			//Color, mix in the noise
			o.Albedo = c.rgb * 0.6 * _Color * tex2D(_Distortion, sin(distortion * (_Time.x*2))).r; 
			//Cubemap reflection
			o.Emission = 0.7 * texCUBE(_Cube, IN.worldRefl * distortion).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			//Change alpha according to distance from center of voronoi cell
			o.Alpha = 0.5*log(minDist+1);
		}
		ENDCG
	}
	Fallback "Diffuse"
}