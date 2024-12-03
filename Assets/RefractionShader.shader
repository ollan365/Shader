Shader "Custom/RefractionShader"
{
    Properties{
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _RefStrength("Reflection Strength", Range(0, 0.1)) = 0.05
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
        zwrite off // 평면이 캡쳐되지 않도록 z 버퍼 꺼두기
        GrabPass{}
        LOD 200
        CGPROGRAM
        #pragma surface surf nolight noambient alpha:fade
        #pragma target 3.0

        sampler2D _MainTex;
        float _RefStrength;
        sampler2D _GrabTexture;

        struct Input
        {
            float4 color:COLOR;
            float4 screenPos;
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o) {
            float4 ref = tex2D(_MainTex, IN.uv_MainTex);
            float3 screenUV = IN.screenPos.rgb / IN.screenPos.a;
            o.Emission = tex2D(_GrabTexture, screenUV.xy + ref.x * _RefStrength);
        }

        float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float atten) {
            return float4(0, 0, 0, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
