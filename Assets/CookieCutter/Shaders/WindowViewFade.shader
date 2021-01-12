Shader "ARWindow/WindowViewFade"
{
    Properties
    {
        _TexOne ("Texture", 2D) = "white" {}
        _TexTwo ("Texture", 2D) = "white" {}
        _FadeTex ("Fade Texture", 2D) = "white" {}
        _MagicTex ("Magic Texture", 2D) = "white" {}
        _FadeBetween ("Fade Between", Range(-0.1, 1.1)) = 0.27
        _MagicSize ("Magic Size", float) = 0.1
        _Contrast("Contrast", float) = 60
        _StencilMask("Stencil mask", Int) = 0
    }
    SubShader
    {
        Tags {
            "IgnoreProjector" = "True"
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
        }
        Pass {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off

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

            sampler2D _TexOne, _TexTwo, _FadeTex, _MagicTex;
            float4 _TexOne_ST;
            float _FadeBetween, _Contrast, _MagicSize;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _TexOne);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv;

                fixed4 col0 = tex2D(_TexOne, uv);
                fixed4 col1 = tex2D(_TexTwo, uv);

                fixed4 magic = tex2D(_MagicTex, uv);
                float4 black = (0,0,0,0);
                float4 noise = tex2D(_FadeTex, uv);

                fixed4 fade = saturate((noise - _FadeBetween) * _Contrast);
                fixed4 glowfade = saturate((noise - _FadeBetween + _MagicSize) * _Contrast);


                // return col0*fade.r + magic*(glowfade.r - fade.r) + col1*(1-glowfade.r);
                return noise * magic;
                // return col0*fade.r  + col1*(1-glowfade.r);
            }
            ENDCG
        }
    }
}
