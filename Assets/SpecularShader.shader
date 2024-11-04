Shader "Custom/SpecularShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("BumpMapTexture", 2D) = "white" {}
        _SpecCol("SpecularColor", Color) = (1, 1, 1, 1)
        _SpecPow("SpecularPow", Range(10, 200)) = 100
        _GlossTex("GlossTexture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Test

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _GlossTex;
        float4 _SpecCol;
        float _SpecPow;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float2 uv_GlossTex;
            float3 viewDir;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutput o) {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Albedo = c.rgb;
            o.Alpha = c.a;

            float4 m = tex2D(_GlossTex, IN.uv_GlossTex);
            o.Gloss = m.a;
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
            specColor = spec * _SpecCol.rgb * s.Gloss;

            // Rim term
            float3 rimColor;
            float rim = abs(dot(viewDir, s.Normal));
            float invRim = rim;
            rimColor = pow(invRim, 6) * float3(0.5, 0.5, 0.5);

            // Final term
            float4 final;
            final.rgb = DiffColor.rgb + specColor.rgb + rimColor;
            final.a = s.Alpha;
            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
