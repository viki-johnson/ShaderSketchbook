Shader "nJam/CookieShader"
{
    Properties
    {
        _MainTex ("Main", 2D) = "white" {}
        _AlphaTex ("Alpha", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
        _TextureMix("Texture Mix", Float) = 0

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
                float2 uv1 : TEXCOORD1;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex, _AlphaTex;
            float4 _MainTex_ST, _AlphaTex_ST, _Color;
            float _TextureMix;

            int _NumColors;
			fixed4 _Color1, _Color2, _Color3, _Color4, _Color5, _Color6;
			int _Tiling;
			float _WidthShift;
			float _Direction;
			float _WarpScale;
			float _WarpTiling;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv1 = TRANSFORM_TEX(v.uv, _AlphaTex);
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

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 alpha = tex2D(_AlphaTex, i.uv1);
                fixed4 col = (tex2D(_MainTex, i.uv)*_TextureMix) + _Color;
                // return fixed4(col.r, col.g, col.b, alpha.a);



                const float PI = 3.14159;

				float2 pos = rotatePoint(i.uv.xy, float2(0.5, 0.5), _Direction * 2 * PI);

				pos.x += sin(pos.y * _WarpTiling * PI * 2) * _WarpScale;
				pos.x *= _Tiling;

				int value = floor((frac(pos.x)) * _NumColors);
				value = clamp(value, 0, _NumColors - 1);
				switch (value) {
                    case 5: return fixed4(_Color6.r, _Color6.g, _Color6.b, alpha.a);
                    case 4: return fixed4(_Color5.r, _Color5.g, _Color5.b, alpha.a);
					case 3: return fixed4(_Color4.r, _Color4.g, _Color4.b, alpha.a);
					case 2: return fixed4(_Color3.r, _Color3.g, _Color3.b, alpha.a);
					case 1: return fixed4(_Color2.r, _Color2.g, _Color2.b, alpha.a);
					default: return fixed4(_Color1.r, _Color1.g, _Color1.b, alpha.a);
				}
            }
            ENDCG
        }
    }
}
