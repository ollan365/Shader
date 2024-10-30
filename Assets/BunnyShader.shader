Shader "Custom/BunnyShader"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _DotProduct("Rim effect", Range(-1, 1)) = 0.25
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
        }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade nolighting // ������ ���� ���� ���̹Ƿ� nolighting �߰�

        sampler2D _MainTex;
        float _DotProduct;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal;
            float3 viewDir; // ī�޶� �ٶ󺸴� ����
        };

        fixed4 _Color;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            float border = 1.0f - (abs(dot(IN.viewDir, IN.worldNormal))); // ���Ⱑ �ٽ�! IN.viewDir: ī�޶�� ���ֺ��� �� ���� ����
            float alpha = (border * (1.0f - _DotProduct) + _DotProduct);
            o.Alpha = c.a * alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
