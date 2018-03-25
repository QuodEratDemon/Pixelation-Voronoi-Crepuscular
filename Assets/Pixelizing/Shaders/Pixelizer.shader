Shader "Shaders/Pixelizer"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_VertRange ("VerticalLines", Range(1,500)) = 20
		_HorizRange ("HorizontalLines", Range(1,500)) = 20
		_LeftPixelSide("LeftPixelSide", Range(0, 1000)) = 20
		_RightPixelSide("RightPixelSide", Range(0, 1000)) = 200
		_TopPixelSide("TopPixelSide", Range(0, 1000)) = 20
		_BottomPixelSide("BottomPixelSide", Range(0, 1000)) = 100
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
			float _VertRange;
			float _HorizRange;

			float _LeftPixelSide;
			float _RightPixelSide;
			float _TopPixelSide;
			float _BottomPixelSide;


			fixed4 frag (v2f i) : SV_Target
			{
				uint screenWidth = (uint) _ScreenParams[0];
				uint screenHeight = (uint) _ScreenParams[1];
				uint screenCoordX = (uint) i.vertex[0];//ComputeScreenPos(i.vertex)[0];
				uint screenCoordY = (uint) i.vertex[1];//screenHeight - i.vertex[1];//ComputeScreenPos(i.vertex)[1];

				if(screenCoordX < (uint)_LeftPixelSide || screenCoordX > (uint)_RightPixelSide){//LeftPixelSide || screenCoordX > RightPixelSide){
					fixed4 col = tex2D(_MainTex, i.uv);
					return col;
				}

				if(screenCoordY > (uint)_TopPixelSide || screenCoordY < (uint)_BottomPixelSide){
					fixed4 col = tex2D(_MainTex, i.uv);
					return col;
				}

				uint HorizontalLines = (uint)_HorizRange;//20;
				uint VerticalLines = (uint)_VertRange;

				//uint HorizontalLinesPos[HorizontalLines];
				uint curValX;
				uint lastValX = 0;

				//uint VerticalLinesPos[VerticalLines];
				uint curValY;
				uint lastValY = 0;

				for(uint j=0; j < HorizontalLines; j++){
					//HorizontalLinesPos[j] = (j+1)*screenWidth / (HorizontalLines + 1);
					//if(screenCoord[0] <= HorizontalLinesPos[j-1] && screenCoord[0] <= HorizontalLinesPos[j-1]
					curValX = (j+1)*screenWidth / (HorizontalLines + 1);
					if(screenCoordX >= lastValX && screenCoordX <= curValX){
						break;
					}else{
						lastValX = curValX;
					}
				}

				for(uint k=0; k < VerticalLines; k++){
					//VerticalLinesPos[k] = (k+1)*screenHeight / (VerticalLines + 1);
					curValY = (k+1)*screenHeight / (VerticalLines + 1);
					if(screenCoordY >= lastValY && screenCoordY <= curValY){
						break;
					}else{
						lastValY = curValY;
					}
				}

				float sampleX = (float)(lastValX + curValX)/2;
				float sampleY = (float)(lastValY + curValY)/2;
				float2 samples = {sampleX/(float)screenWidth, sampleY/(float)screenHeight};

				//float2 samples = {(float)(lastValX + curValX)/2,(float)(lastValY + curValY)/2};

				fixed4 col = tex2D(_MainTex, samples);
				return col;

//				if(j == 0 || k == 0){
//					return fixed4(1,1,1,1);
//				}else if(j == 20 || k == 20){
//					return fixed4(0,0,0,1);
//				}else if((lastValX + curValX)/2 > 6*screenWidth / (HorizontalLines + 1) && (lastValY + curValY)/2 > 6*screenHeight / (VerticalLines + 1)){//j == 5 || k == 5){
//					return fixed4(1,0,1,1);
//				}else{
//					return fixed4(0,0,1,1);
//				}//else if(){
//
//				}else if(){
//
//				}else if(){
//
//				}else if(){
//
//				}
			}
			ENDCG
		}
	}
}
