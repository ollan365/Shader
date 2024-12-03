Shader "Custom/AlphaShader"
{
    Properties
    {
        // _Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
        // _Cutoff("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader
    {
        // Tags { "RenderType"="TransparentCutout" "Queue" = "AlphaTest" }
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
        // cull off
        LOD 200

        zwrite on // 거리 정보만을 z버퍼에 담아둠
        ColorMask 0
        CGPROGRAM
        #pragma surface surf nolight noambient noforwardadd nolightmap novertexlights noshadow

        struct Input
        {
            float4 color:COLOR;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
        }

        float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float atten){
            return float4(0,0,0,0);
        }
        ENDCG


        zwrite off // 앞서 담아둔 z 버퍼 기준으로 그리기 때문에, 뒷부분은 그려지지 않고 앞부분만 깔끔하게 반투명으로 그려짐
        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = 0.5;
        }
        ENDCG
    }
    // FallBack "Legacy Shaders/Transparent/Cutout/VertexLit" // 그림자 사라짐~
    FallBack "Diffuse"
}
