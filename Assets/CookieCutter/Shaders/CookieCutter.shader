Shader "Cookie Maker/Cookie Cutter"
{
    Properties
    {
        _MainTex  ("Main Tex", 2D) = ""{}
        _Distance ("Thickness", Float) = 1
        _Color    ("Colour", Color) = (1, 0, 0, 0)

    }

    Subshader
    {
        Tags {
            "IgnoreProjector" = "True"
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
        }
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag


    #include "UnityCG.cginc"

    sampler2D _MainTex;
    float4 _MainTex_TexelSize;
    float _Distance;
    half4 _Color;

    half4 frag(v2f_img i) : SV_Target 
    {
        // Simple sobel filter for the alpha channel.
        float d = _MainTex_TexelSize.xy * _Distance;

        half a1 = tex2D(_MainTex, i.uv + d * float2(-1, -1)).a;
        half a2 = tex2D(_MainTex, i.uv + d * float2( 0, -1)).a;
        half a3 = tex2D(_MainTex, i.uv + d * float2(+1, -1)).a;

        half a4 = tex2D(_MainTex, i.uv + d * float2(-1,  0)).a;
        half a6 = tex2D(_MainTex, i.uv + d * float2(+1,  0)).a;

        half a7 = tex2D(_MainTex, i.uv + d * float2(-1, +1)).a;
        half a8 = tex2D(_MainTex, i.uv + d * float2( 0, +1)).a;
        half a9 = tex2D(_MainTex, i.uv + d * float2(+1, +1)).a;

        float gx = - a1 - a2*2 - a3 + a7 + a8*2 + a9;
        float gy = - a1 - a4*2 - a7 + a3 + a6*2 + a9;

        float w = saturate(sqrt(gx * gx + gy * gy));

        // Mix the contour color.
        half4 source = tex2D(_MainTex, i.uv);

        float4 white = (1,1,1,1);
        float4 black = (0,0,0,0);
        fixed4 alpha = lerp(black, white, w);

        float4 col = (_Color.r, _Color.g, _Color.b, w);

        return _Color*col;
        // return w * _Color;

    }

    ENDCG 
        }
    }
}