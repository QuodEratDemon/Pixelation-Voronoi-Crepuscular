///////////////////////////////////////////////////////////////////////////////
//  RadialBlur.shader
//
//  Upgrade NOTE: replaced 'samplerRECT' with 'sampler2D'
//  Upgrade NOTE: replaced 'texRECT' with 'tex2D'
//
//	original code from: http://forum.unity3d.com/threads/radial-blur.31970/	
// 
//  (c)2015 Kim, Hyoun Woo
///////////////////////////////////////////////////////////////////////////////

Shader "FX/RadialBlur"
{
    Properties 
    {
        _MainTex ("Input", RECT) = "white" {}
        _MaskTex ("Mask Texture", RECT) = "white" {}
        _BlurStrength ("", Float) = 0.5
        _BlurWidth ("", Float) = 0.5
        _LPX ("", Float) = 0.0
        _LPY ("", Float) = 0.0
        _Threshold ("", Float) = 1.5
    }

    SubShader 
    {
        Pass 
        {
            ZTest Always Cull Off ZWrite Off
            Fog { Mode off }
       
            CGPROGRAM
   
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
 
            #include "UnityCG.cginc"
 
            uniform sampler2D _MainTex;
            uniform sampler2D  _MaskTex;
            uniform half4 _MainTex_TexelSize;
            uniform half _BlurStrength;
            uniform half _BlurWidth;
            uniform half _imgWidth;
            uniform half _imgHeight;

            float _LPX;
            float _LPY;
            float _Threshold;
 
            half4 frag (v2f_img i) : COLOR 
            {

            	fixed4 col = tex2D(_MaskTex, i.uv);
				//if (col.r + col.g + col.b > _Threshold){
					//col = fixed4(1.,1.,1.,1.);
				//}else{
					//col = fixed4(0,0,0,1.);
				//}


                half4 color = col ; //tex2D(_MainTex, i.uv);
       
                // some sample positions
                half samples[10];
                samples[0] = -0.08;
                samples[1] = -0.05;
                samples[2] = -0.03;
                samples[3] = -0.02;
                samples[4] = -0.01;
                samples[5] =  0.01;
                samples[6] =  0.02;
                samples[7] =  0.03;
                samples[8] =  0.05;
                samples[9] =  0.08;
       
                //vector to the middle of the screen
                 half2 dir = 0.5 * half2(_imgHeight,_imgWidth) - i.uv;

       
                //distance to center
                half dist = sqrt(dir.x*dir.x + dir.y*dir.y);
       
                //normalize direction
                dir = dir/dist;
       
                //additional samples towards center of screen
                half4 sum = color;
                for(int n = 0; n < 10; n++)
                {

	                //fixed4 col1 = tex2D(_MainTex, i.uv);
					//if (col1.r + col1.g + col1.b > _Threshold){
						//col1 = fixed4(1.,1.,1.,1.);
					//}else{
						//col1 = fixed4(0,0,0,1.);
					//}

                    //sum += tex2D(_MainTex, i.uv + dir * samples[n] * _BlurWidth * _imgWidth) + col1;
                   //float2 pos =  max(min(i.uv, dir) , float2(0.0,0.0));
                   sum += tex2D(_MaskTex, i.uv + dir * samples[n] * _BlurWidth);

                }
                //float grayscale = dot(sum.rgb, float3(0.3, 0.59, 0.11));

                //sum.r = grayscale;
                //sum.g = grayscale;
                //sum.b =grayscale;
                //eleven samples...
                sum *= 1.0/11.0;
       
                //weighten blur depending on distance to screen center

                //half t = dist * _BlurStrength / _imgWidth;
                //t = clamp(t, 0.0, 1.0);
                		
                //half t = saturate(dist * _BlurStrength);
       			half t = dist * _BlurStrength;
                //blend original with blur
                fixed4 col0 = tex2D(_MainTex, i.uv);
                t = clamp(t, 0.0, 1.0);
                return lerp(color, sum, t) + col0;
            }
            ENDCG
        }
    }
}