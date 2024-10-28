Shader "Custom/VertexShader"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _MainTex2("Albedo (RGB)", 2D) = "white" {}
        _MainTex3("Albedo (RGB)", 2D) = "white" {}
        _MainTex4("Albedo (RGB)", 2D) = "white" {}
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        sampler2D _MainTex;
        sampler2D _MainTex2;
        sampler2D _MainTex3;
        sampler2D _MainTex4;

        struct Input
        {
            float2 uv_MainTex; // 여러 texture를 받더라도 texture의 크기가 같다면 하나만 써도 됨
            float4 color : COLOR; // 오브젝트가 내부적으로 본인의 색이 있다면 그 색을 받음
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            fixed4 d = tex2D(_MainTex2, IN.uv_MainTex);
            fixed4 e = tex2D(_MainTex3, IN.uv_MainTex);
            fixed4 f = tex2D(_MainTex4, IN.uv_MainTex);

            // o.Albedo = c.rgb * IN.color.rgb;

            // 4가지 텍스쳐를 섞는 방법
            o.Albedo = lerp(c.rgb , d.rgb, IN.color.r);
            o.Albedo = lerp(o.Albedo , e.rgb, IN.color.g);
            o.Albedo = lerp(o.Albedo , f.rgb, IN.color.b);

            o.Alpha = c.a;
        }
        ENDCG
    }
        FallBack "Diffuse"
}