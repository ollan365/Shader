Shader "Custom/SpecularShader"
{
    Properties
    {
        _MainTint("Diffuse Tint", Color) = (1,1,1,1)
        _MainTex("Base", 2D) = "white" {}
        _SpecularColor("Color", Color) = (1,1,1,1)
        _SpecPower("Smoothness", Range(0,30)) = 1
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Phong

        sampler2D _MainTex;
        float4 _SpecularColor;
        float4 _MainTint;
        float _SpecPower;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        fixed4 LightingPhong(SurfaceOutput s, fixed3 lightDir, float3 viewDir, fixed atten) {
            float NodtL = dot(s.Normal, lightDir);
            float3 rVec = normalize(2.0 * s.Normal * NodtL - lightDir);

            float spec = pow(max(0, dot(rVec, viewDir)), _SpecPower);
            float3 finalSpec = _SpecularColor.rgb * spec;

            fixed4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * max(0, NodtL) * atten) + (_LightColor0.rgb * finalSpec);
            c.a = s.Alpha;
            return c;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
