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
        #pragma surface surf Lambert alpha:fade nolighting // 조명을 쓰지 않을 것이므로 nolighting 추가

        sampler2D _MainTex;
        float _DotProduct;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal;
            float3 viewDir; // 카메라가 바라보는 방향
        };

        fixed4 _Color;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            float border = 1.0f - (abs(dot(IN.viewDir, IN.worldNormal))); // 여기가 핵심! IN.viewDir: 카메라랑 마주보는 게 가장 밝음
            float alpha = (border * (1.0f - _DotProduct) + _DotProduct);
            o.Alpha = c.a * alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
