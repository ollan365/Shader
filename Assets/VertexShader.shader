Shader "Custom/VertexShader"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _MainTex2("Albedo (RGB)", 2D) = "white" {}
        _MainTex3("Albedo (RGB)", 2D) = "white" {}
        _MainTex4("Albedo (RGB)", 2D) = "white" {}
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        sampler2D _MainTex;
        sampler2D _MainTex2;
        sampler2D _MainTex3;
        sampler2D _MainTex4;

        struct Input
        {
            float2 uv_MainTex; // ���� texture�� �޴��� texture�� ũ�Ⱑ ���ٸ� �ϳ��� �ᵵ ��
            float4 color : COLOR; // ������Ʈ�� ���������� ������ ���� �ִٸ� �� ���� ����
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            fixed4 d = tex2D(_MainTex2, IN.uv_MainTex);
            fixed4 e = tex2D(_MainTex3, IN.uv_MainTex);
            fixed4 f = tex2D(_MainTex4, IN.uv_MainTex);

            // o.Albedo = c.rgb * IN.color.rgb;

            // 4���� �ؽ��ĸ� ���� ���
            o.Albedo = lerp(c.rgb , d.rgb, IN.color.r);
            o.Albedo = lerp(o.Albedo , e.rgb, IN.color.g);
            o.Albedo = lerp(o.Albedo , f.rgb, IN.color.b);

            o.Alpha = c.a;
        }
        ENDCG
    }
        FallBack "Diffuse"
}