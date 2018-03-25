Shader "Shaders/Masking"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Threshold("Threshold", Float) = 1.75
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				 
				
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;

			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;

				return o;
			}
			
			sampler2D _MainTex;
			float _Threshold;

			float4 frag (v2f i) : COLOR
			{
				//fixed4 col = tex2D(_MainTex, i.uv);
				//if (col.r + col.g + col.b > _Threshold){
					//col = fixed4(1.,1.,1.,1.);
				//}else{
					//col = fixed4(0,0,0,1.);
				//}
				float4 col = tex2D(_MainTex, i.uv);
				float greyscale = dot(col.rgb, float3(0.3, 0.59, 0.11));
				col.r = greyscale;
				col.g = greyscale;
				col.b = greyscale;

				if (col.r > _Threshold){
					col = fixed4(1.,1.,1.,1.);
				}else{
					col = fixed4(0,0,0,1.);
				}
				return col;
			}
			ENDCG
		}
	}
}
