// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Cookie Maker/Cookie Dough" {
    Properties{
        _MainTex("Main Texture", 2D) = "white" {}
        _NoiseTex("Noise Texture", 2D) = "white" {}
        _Intensity("Intensity", Float) = 0
        _VRadius("Vignette Radius", Range(0.0, 1.0)) = 1.0
        _VSoft("Vignette Softness", Range(0.0, 1.0)) = 0.5
        _offset("offset", Float) = 0
        _CookieMask("PaintMap", 2D) = "white" {}
        _CookieTex("Cookie Texture", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
        _TextureMix("Texture Mix", float) = 0


        // stripes
        [IntRange] _NumColors ("Number of colors", Range(2, 6)) = 2
        _Color1 ("Color 1", Color) = (0,0,0,1)
		_Color2 ("Color 2", Color) = (1,1,1,1)
		_Color3 ("Color 3", Color) = (1,0,1,1)
		_Color4 ("Color 4", Color) = (0,0,1,1)
        _Color5 ("Color 5", Color) = (0,0,1,1)
        _Color6 ("Color 6", Color) = (0,0,1,1)
		_Tiling ("Tiling", Range(1, 20)) = 10
		_Direction ("Direction", Range(0, 1)) = 0
		_WarpScale ("Warp Scale", Range(0, 1)) = 0
		_WarpTiling ("Warp Tiling", Range(1, 10)) = 1

    }
    SubShader{
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
 
            sampler2D _MainTex, _NoiseTex, _CookieTex, _CookieMask;
            float4 _MainTex_ST, _NoiseTex_ST, _CookieTex_ST;
            float4 _Color;
            float _Intensity, _VRadius, _VSoft, _offset, _TextureMix;


            int _NumColors;
			fixed4 _Color1, _Color2, _Color3, _Color4, _Color5, _Color6;
			int _Tiling;
			float _WidthShift;
			float _Direction;
			float _WarpScale;
			float _WarpTiling;
 
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float4 vertexColor : COLOR;
            };
 
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 vertexColor : COLOR;
            };
 
            VertexOutput vert(VertexInput v) {
                VertexOutput o;
                o.uv0 = TRANSFORM_TEX(v.texcoord0, _MainTex);
                o.uv1 = TRANSFORM_TEX(v.texcoord1, _NoiseTex);
                o.uv2 = TRANSFORM_TEX(v.texcoord2, _CookieTex);
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos(v.vertex);
 
                return o;
            }

            float2 rotatePoint(float2 pt, float2 center, float angle) {
				float sinAngle = sin(angle);
				float cosAngle = cos(angle);
				pt -= center;
				float2 r;
				r.x = pt.x * cosAngle - pt.y * sinAngle;
				r.y = pt.x * sinAngle + pt.y * cosAngle;
				r += center;
				return r;
			}
 
            float4 frag(VertexOutput i) : COLOR {
                float4 noiseTex = tex2D(_NoiseTex, i.uv1);
                float2 offset = (noiseTex.rg * 2 - 1) * _Intensity;
                float2 uvNoise = i.uv0 + offset;
                float4 mainTex = tex2D(_MainTex, uvNoise);

                half4 paint = (tex2D(_CookieMask, i.uv0));
                float4 alpha = mainTex * (1-paint.g);


                float4 col = (tex2D(_CookieTex, i.uv2)*_TextureMix) + _Color;
                // float4 col = tex2D(_CookieTex, i.uv2);
 
                // return alpha.r * col;
                // return fixed4(col.r, col.g, col.b, alpha.r);
                // return col;
                

                // make some stripes

                const float PI = 3.14159;

				float2 pos = rotatePoint(i.uv2.xy, float2(0.5, 0.5), _Direction * 2 * PI);

				pos.x += sin(pos.y * _WarpTiling * PI * 2) * _WarpScale;
				pos.x *= _Tiling;

				int value = floor((frac(pos.x)) * _NumColors);
				value = clamp(value, 0, _NumColors - 1);
				switch (value) {
                    case 5: return fixed4(_Color6.r, _Color6.g, _Color6.b, alpha.r);
                    case 4: return fixed4(_Color5.r, _Color5.g, _Color5.b, alpha.r);
					case 3: return fixed4(_Color4.r, _Color4.g, _Color4.b, alpha.r);
					case 2: return fixed4(_Color3.r, _Color3.g, _Color3.b, alpha.r);
					case 1: return fixed4(_Color2.r, _Color2.g, _Color2.b, alpha.r);
					default: return fixed4(_Color1.r, _Color1.g, _Color1.b, alpha.r);
				}
            }
            ENDCG
        }
    }
}