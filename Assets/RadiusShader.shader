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
            float3 worldPos; // ����
        };

        fixed4 _Color;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float d = distance(_Center, IN.worldPos); // ���Ϳ��� ������ǥ������ �Ÿ�
            if ((d > _Radius) && (d < (_Radius + _RadiusWidth))) { // ���� ���ʺ��� ũ�� ���� �ٱ��ʺ��� ���� �κ�
                o.Albedo = _RadiusColor; // Ư�� ������ ĥ�Ѵ�
            }
            else { // �� ���� �κ��� ���� ������
                o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
            }
        }
        ENDCG
    }
    FallBack "Diffuse"
}