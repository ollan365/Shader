Shader "Custom/SpecularShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("Albedo (RGB)", 2D) = "white" {}
        _SpecCol("SpecularColor", Color) = (1, 1, 1, 1)
        _SpecPow("SpecularPow", Range(10, 200)) = 100
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Test

        sampler2D _MainTex;
        sampler2D _BumpMap;
        float4 _SpecCol;
        float _SpecPow;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float3 viewDir;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutput o) {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        float4 LightingTest(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten) {
            float3 DiffColor;
            float nDotL = saturate(dot(s.Normal, lightDir));
            DiffColor = nDotL * s.Albedo * _LightColor0.rgb * atten;
            
            // Specular term
            float3 halfVec = normalize(lightDir + viewDir);
            float spec = saturate(dot(halfVec, s.Normal));
            spec = pow(spec, _SpecPow);
            float3 specColor;
            specColor = spec * _SpecCol.rgb;

            // Final term
            float4 final;
            final.rgb = DiffColor.rgb + specColor.rgb;
            final.a = s.Alpha;
            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
