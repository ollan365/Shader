Shader "Custom/ChalShader"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("Normalmap", 2D) = "bump" {}
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Test // noambient를 끈다 -> noambient gpt 한테 물어보기

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        float4 LightingTest(SurfaceOutput s, float3 lightDir, float atten) {
            float nDotL = dot(s.Normal, lightDir) * 0.5 + 0.5;
            nDotL = pow(nDotL, 2);
            float4 final;
            // final.rgb = nDotL * s.Albedo * _LightColor0; // _LightColor0: 외부 조명의 색을 적용
            final.rgb = nDotL * s.Albedo * _LightColor0 * atten; // soft shadow 적용을 위해 atten 을 곱함
            // hard shadow / soft shadow: 빛을 비춰 메쉬에 닿으면 그림자 X 닿지 못하면 그림자
            // 위의 과정만 적용하면 그 경계가 명확하므로 hard, 완만하게 변하게 하기 위해 atten을 곱해 soft로
            final.a = s.Alpha;
            return final;
        }
        ENDCG
    }
        FallBack "Diffuse"
}