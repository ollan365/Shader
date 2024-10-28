Shader "Custom/LambertShader"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _SpecColor("Speclar Color", color) = (1,1,1,1) // 다른 변수명은 허용되지 않음, 컨트롤 변수를 만들면 안됨, BlinnPhong 내부적으로 알아서 찾아서 작동
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