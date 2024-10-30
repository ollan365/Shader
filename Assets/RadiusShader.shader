Shader "Custom/RadiusShader"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Center("Center", Vector) = (200, 0, 200, 0)
        _Radius("Radius", Float) = 100
        _RadiusColor("Radius Color", Color) = (1,0,0,1)
        _RadiusWidth("Radius Width", Float) = 0.1
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        float3 _Center;
        float _Radius;
        fixed4 _RadiusColor;
        float _RadiusWidth;
        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos; // 원점
        };

        fixed4 _Color;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float d = distance(_Center, IN.worldPos); // 센터에서 월드좌표까지의 거리
            if ((d > _Radius) && (d < (_Radius + _RadiusWidth))) { // 원의 안쪽보다 크고 원의 바깥쪽보다 작은 부분
                o.Albedo = _RadiusColor; // 특정 색으로 칠한다
            }
            else { // 그 외의 부분은 원래 색으로
                o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
            }
        }
        ENDCG
    }
    FallBack "Diffuse"
}