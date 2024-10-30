Shader "Custom/EmilyShader"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf Test noambient

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        float4 LightingTest(SurfaceOutput s, float3 lightDir, float atten)
        {
            // �ڻ��� ���� -1���� 1���� ���� ���簪�� �ſ� Ƣ�� �� -> saturate: ���� 0���� 1�� �ٲ���
            float nDotL = saturate(dot(s.Normal, lightDir));
            return nDotL;
        }

        ENDCG
    }
    FallBack "Diffuse"
}