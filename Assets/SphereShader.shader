Shader "Custom/SphereShader"
{
    Properties // 화면 상에 보이는 부분
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

        CGPROGRAM // 여기서부터 ENDCG까지 코딩 가능한 부분
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows // 쉐이더 설정 (그림자 유무, 물리 기반 쉐이더 등등)

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0  // 쉐이더 버전

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex; // 해당 uv 좌표에 해당하는 픽셀
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
            // fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color; // 해당 uv 좌표에 해당하는 픽셀의 컬러값에 _Color를 곱함

            // o.Albedo = float3(1, 0, 0); // 조명에 영향을 받음
            // o.Emission = float3(1, 0, 0); // 조명에 영향을 받지 않음

            // fixed4 c = tex2D(_MainTex, IN.uv_MainTex)*_Color;
            // o.Emission = float3(1, 0, 0) * float3(0, 1, 0);

            // float4 test = float4(1, 0, 0, 1);
            // fixed4 c = tex2D(_MainTex, IN.uv_MainTex)*_Color;
            // o.Albedo = test.b; // test의 b에 해당하는 0을 토대로, (0,0,0)이 할당됨

            // float r = 1;
            // float2 gg = float2(0.5, 0);
            // fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            // o.Albedo = float3(r, gg); // float와 float2로 float3를 나타낼 수 있음

            // fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            // o.Albedo = _TestColor.rgb; // 인스펙터 창에서 testColor를 바꾸면 실시간으로 적용됨


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