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

Shader "FX/Radial"
{
    Properties 
    {
        _MainTex ("Input", RECT) = "white" {}
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
            	float3 p = i.pos.xyz/float3(_imgHeight,_imgWidth,1.0) - 0.5;
            	fixed4 col = tex2D(_MainTex, 0.5+(i.uv*=.992));

				

                half3 color = half3(col.r, col.b, col.b) ; 
       
                
                //vector to the middle of the screen
                 half2 dir = 0.5 * half2(_imgHeight,_imgWidth) - i.uv;

       
                //distance to center
                half dist = sqrt(dir.x*dir.x + dir.y*dir.y);
       
                //normalize direction
                dir = dir/dist;
       
                //additional samples towards center of screen
                half3 sum = color;
                for(int n = 0; n < 100; n++)
                {
                	
	                p.z += pow(max(0.0,0.5-length(col.rg)),2.0) * exp(-n*0.8);

                }
                //float grayscale = dot(sum.rgb, float3(0.3, 0.59, 0.11));

                //sum.r = grayscale;
                //sum.g = grayscale;
                //sum.b =grayscale;
                //eleven samples...
                //sum *= 1.0/101.0;
       
                //weighten blur depending on distance to screen center

                //half t = dist * _BlurStrength / _imgWidth;
                //t = clamp(t, 0.0, 1.0);
                		
                //half t = saturate(dist * _BlurStrength);
       
                //blend original with blur
                //fixed4 col0 = tex2D(_MainTex, i.uv);

                //return lerp(color, sum, t) * col0;
                return half4(color*color + p.z,1.0);
            }
            ENDCG
        }
    }
}