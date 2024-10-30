Shader "Custom/SphereShader"
{
    Properties
    {
        _MainTint("Diffuse Tint", Color) = (0,1,0,1)
        _NormalTex("Normal Map", 2D) = "bump" {}
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        #pragma target 3.0

        sampler2D _NormalTex;
        float4 _MainTint;

        struct Input
        {
            float2 uv_NormalTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutputStandard o) {
            o.Albedo = _MainTint;
            float3 n = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
            o.Normal = n.rgb;
        }
        ENDCG
    }
        FallBack "Diffuse"
}