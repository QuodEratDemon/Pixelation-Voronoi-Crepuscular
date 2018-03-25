Shader "Caustics/Voronoi Diagram"
{
	Properties
	{
		_Radius("Radius", Range(0,0.25)) = 0.23
		_P("P", Range(1,2)) = 2
		_Size("Plane Size", Vector) = (0.0, 0.0, 0.0, 0.0)
	}

	SubShader
	{
		Tags {"RenderType" = "Transparent" "Queue" = "Transparent"}
		Blend SrcAlpha OneMinusSrcAlpha
		
		Pass
		{
			CGPROGRAM

			#pragma vertex vert             
			#pragma fragment frag

			uniform half _P;
			uniform half _Radius;
			uniform int _Length = 0;
			uniform fixed2 _Points[100];
			uniform fixed2 _Size;
			uniform fixed3 _Colors[100];

			struct vertInput {
				float4 pos : POSITION;
			};

			struct vertOutput {
				float4 pos : POSITION;
				fixed3 worldPos : TEXCOORD1;
			};

			vertOutput vert(vertInput input) {
				vertOutput o;
				o.pos = UnityObjectToClipPos(input.pos);
				o.worldPos = mul(unity_ObjectToWorld, input.pos).xyz;
				return o;
			}

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

			fixed4 frag(vertOutput output) : COLOR{
				half minDist = 100000;
				int minI = 1;	// Index of min
				for (int i = 0; i < _Length; i++)
				{
					half dist = distance_minkowski(output.worldPos.xy, _Points[i].xy * _Size.xy);
					if (dist < _Radius)
						return fixed4(0, 0, 0, 1);
					if (dist < minDist)
					{
						minDist = dist;
						minI = i;
					}
				}
				//Steps: 

				return fixed4(_Colors[minI], 0.5*log(minDist+1));
			}
		  ENDCG
		  }
	}
	Fallback "Diffuse"
}