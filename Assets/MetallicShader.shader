Shader "Custom/MetallicShader"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0,1)) = 0.5
        _Metallic("Metallic", Range(0,1)) = 0.0
        _BumpMap("Normal map", 2D) = "bump" {}
        _Occlusion("Occlusion", 2D) = "white" {}
        _Specular("Specular", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _Occlusion;
        sampler2D _Specular;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        half _Glossiness;
        half _Metallic;

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            fixed3 n = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Normal = n; // 굴곡진 것처럼 보이도록 음영 추가
            o.Albedo = c.rgb;
            o.Occlusion = tex2D(_Occlusion, IN.uv_MainTex); // 깊이 파인 홈에 그림자 같은거 추가
            o.Metallic = tex2D(_Specular, IN.uv_MainTex) * 3.0;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}