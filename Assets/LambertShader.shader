Shader "Custom/LambertShader"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _SpecColor("Speclar Color", color) = (1,1,1,1) // �ٸ� �������� ������ ����, ��Ʈ�� ������ ����� �ȵ�, BlinnPhong ���������� �˾Ƽ� ã�Ƽ� �۵�
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 200

            CGPROGRAM
            #pragma surface surf BlinnPhong

            sampler2D _MainTex;

            struct Input
            {
                float2 uv_MainTex;
            };

            fixed4 _Color;

            UNITY_INSTANCING_BUFFER_START(Props)
            UNITY_INSTANCING_BUFFER_END(Props)

            void surf(Input IN, inout SurfaceOutput o)
            {
                fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
                o.Albedo = c.rgb;
                o.Specular = 0.5;
                o.Gloss = 1;
                o.Alpha = c.a;
            }
            ENDCG
        }
            FallBack "Diffuse"
}