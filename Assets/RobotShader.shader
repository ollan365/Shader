Shader "Custom/RobotShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Matcap("Matcap", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert noambient

        sampler2D _MainTex;
        sampler2D _Matcap;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            float3 viewNormal = mul((float3x3)UNITY_MATRIX_V, IN.worldNormal.rgb);
            float2 matCapUV = viewNormal.xy * 0.5 + 0.5;
            o.Emission = tex2D(_Matcap, matCapUV);
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
