Shader "Custom/SphereShader"
{
    Properties // ȭ�� �� ���̴� �κ�
    {
        _Brightness("Change Brightness", Range(0,10)) = 0.5
        _TestColor("Test Color", Color) = (1,1,1,1)
        _TestFloat("Test Float", Float) = 0.5
        _TestVector("Test Vector", Vector) = (1,1,1,1)
        _TestTexture("Test Texture", 2D) = "white" {}

        _Red("Red", Range(0,1)) = 0
        _Green("Green", Range(0,1)) = 0
        _Blue("Blue", Range(0, 1)) = 0

        _BrightDark("Brightness & Darkness", Range(-1, 1)) = 0

        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0,1)) = 0.5
        _Metallic("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM // ���⼭���� ENDCG���� �ڵ� ������ �κ�
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows // ���̴� ���� (�׸��� ����, ���� ��� ���̴� ���)

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0  // ���̴� ����

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex; // �ش� uv ��ǥ�� �ش��ϴ� �ȼ�
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float4 _TestColor;

        float _Red;
        float _Green;
        float _Blue;

        float _BrightDark;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            // fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color; // �ش� uv ��ǥ�� �ش��ϴ� �ȼ��� �÷����� _Color�� ����

            // o.Albedo = float3(1, 0, 0); // ���� ������ ����
            // o.Emission = float3(1, 0, 0); // ���� ������ ���� ����

            // fixed4 c = tex2D(_MainTex, IN.uv_MainTex)*_Color;
            // o.Emission = float3(1, 0, 0) * float3(0, 1, 0);

            // float4 test = float4(1, 0, 0, 1);
            // fixed4 c = tex2D(_MainTex, IN.uv_MainTex)*_Color;
            // o.Albedo = test.b; // test�� b�� �ش��ϴ� 0�� ����, (0,0,0)�� �Ҵ��

            // float r = 1;
            // float2 gg = float2(0.5, 0);
            // fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            // o.Albedo = float3(r, gg); // float�� float2�� float3�� ��Ÿ�� �� ����

            // fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            // o.Albedo = _TestColor.rgb; // �ν����� â���� testColor�� �ٲٸ� �ǽð����� �����


            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = float3(_Red, _Green, _Blue) + _BrightDark;

            // o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            // o.Metallic = _Metallic;
            // o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}