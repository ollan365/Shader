Shader "Custom/ChalShader"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _HologramColor("HologramColor", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert noambient alpha:fade


        sampler2D _MainTex;
        float4 _HologramColor;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
            float3 worldPos;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            float rim = saturate(dot(o.Normal, IN.viewDir));
            rim = pow(1 - rim, 3) + pow(frac(IN.worldPos.g * 0.3 - _Time.y) , 30);
            o.Emission = _HologramColor.rgb;
            o.Alpha = rim;
        }
        ENDCG
    }
    FallBack "Diffuse"
}