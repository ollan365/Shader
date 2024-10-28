Shader "Custom/SphereShader"
{
    Properties // ȭ�� �� ���̴� �κ�
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {} // 3D�� ���̳� ���� ���� ǥ���� �� ���
        _MainTex2("Albedo (RGB)", 2D) = "white" {}

        _lerpTest("lerp", Range(0,1)) = 0
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        sampler2D _MainTex;
        sampler2D _MainTex2;

        float _lerpTest;

        struct Input
        {
            float2 uv_MainTex; // �ش� uv ��ǥ�� �ش��ϴ� �ȼ�
            float2 uv_MainTex2;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            fixed4 d = tex2D(_MainTex2, IN.uv_MainTex2);
            // o.Albedo = c.rgb;
            // o.Albedo = (c.r+c.g+c.b)/3; �ش� �ؽ����� ��⸦ ���� �� ����
            // Lerp: �ӵ��� ���� �ǽð��� ������ �����ϳ�, ���̰� �������� �ʴ´ٴ� ���� ������ ����
            // o.Albedo = lerp(c.rgb, d.rgb, _lerpTest);
            o.Albedo = lerp(c.rgb,d.rgb,1 - c.a);
            // png ������ ���İ����� �����Ѵ�
            // �׳� c.a�� ������ ���� ��濡 Ǯ �κ��� �𷡰� �����ϱ�, �ݴ�� �ϱ� ���� 1-c.a�� �ִ´�
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}