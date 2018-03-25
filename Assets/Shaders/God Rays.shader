Shader "Shaders/God Rays"
{


	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Exposure ("Exposure", Float) = 50
		_Decay ("Decay", Float) = 0
		_Weight ("Weight", Float) = 0
		_Density("Density", Float) = 0
		_LightPositionX ("Light position X", Float) = 0
		_LightPositionY ("Light position Y", Float) = 0
		OcclusionMap("Occlusion", 2D) = "white" {}

	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always


		Tags { "LightMode" = "ForwardBase" }

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

			//vs output
			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			//vs
			v2f vert (appdata v)
			{
				v2f Output;

				Output.vertex = UnityObjectToClipPos(v.vertex);
				//Output.vertex.x = v.vertex.x * 2.0f;
				//Output.vertex.y = v.vertex.y * 2.0f; 
				//Output.vertex.z = 0.0f; 
				//Output.vertex.w = 1.0f; 
				Output.uv = v.uv; 
				return Output;
			}

			float _Density;
			float _Weight;
			float _Decay;
			float _Exposure;
			float _LightPositionX;
			float _LightPositionY;

			//texture OcclusionMap;
			sampler2D OcclusionMap;
			sampler OcclusionSampler = sampler_state
			{
			  texture = <OcclusionMap>;	
			};


			sampler2D _MainTex;
			static const int NUM_SAMPLES = 100;
			//float4 _WorldSpaceLightPos0;

			//fs
			float4 frag (v2f i) : COLOR
			{
					float2 _LightPosition = float2(normalize(_WorldSpaceLightPos0.xy));
				  float2 deltaTexCoord = (i.uv - _LightPosition.xy);  
				  deltaTexCoord *= _Density / NUM_SAMPLES;  
				  float4 color = tex2D(_MainTex, i.uv); 
				  float illuminationDecay = 1.0f;  
				  for (int j = 0; j < NUM_SAMPLES; j++)  
				  {  
				    i.uv -= deltaTexCoord;  
				    float4 sample = tex2D(OcclusionMap, i.uv);  
				    sample *= illuminationDecay * _Weight;  
				    color += sample;  
				    illuminationDecay *= _Decay;  
				  }  

				  fixed4 col = tex2D(_MainTex, i.uv);

				  float4 finalColor = color * _Exposure;
				 
				  //finalColor *= col;
				  return finalColor;
			}

//			technique Tech1
//			{
//			  pass pass0
//			  {
//			    vertexshader = compile vs_3_0 vert();
//			    pixelshader  = compile ps_3_0 frag();
//			    AlphaBlendEnable = true;
//			    BlendOp = Add;	
//			    SrcBlend = One;
//			    DestBlend = One;
//			  }
//			}

			ENDCG
		}


	}




}


