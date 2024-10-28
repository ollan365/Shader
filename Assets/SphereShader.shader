Shader "Custom/SphereShader"
{
    Properties // 화면 상에 보이는 부분
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {} // 3D는 불이나 연기 등을 표현할 때 사용
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
            float2 uv_MainTex; // 해당 uv 좌표에 해당하는 픽셀
            float2 uv_MainTex2;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            fixed4 d = tex2D(_MainTex2, IN.uv_MainTex2);
            // o.Albedo = c.rgb;
            // o.Albedo = (c.r+c.g+c.b)/3; 해당 텍스쳐의 밝기를 구할 수 있음
            // Lerp: 속도가 빨라 실시간성 보장이 가능하나, 길이가 보존되지 않는다는 등의 단점이 있음
            // o.Albedo = lerp(c.rgb, d.rgb, _lerpTest);
            o.Albedo = lerp(c.rgb,d.rgb,1 - c.a);
            // png 파일은 알파값까지 저장한다
            // 그냥 c.a를 넣으면 검은 배경에 풀 부분이 모래가 나오니까, 반대로 하기 위해 1-c.a를 넣는다
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}