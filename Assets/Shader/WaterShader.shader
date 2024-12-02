Shader "Custom/WaterShader"
{
    Properties
    {
        _MainTex("tex", 2D) = "white" {}
        _CUBE("Cubemap", CUBE) = "" {}
        _BumpTex("Normal map", 2D) = "white" {}

        _SpColor("Specular Color", Color) = (1,1,1,1)
        _SpPower("Specular Power", Range(10, 500)) = 150
        _SpIntensity("Specular Intensity", Range(0, 10)) = 3
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent"}
        LOD 200

        CGPROGRAM
        #pragma surface surf water alpha:blend vertex:vert
        #pragma target 3.0

        sampler2D _MainTex;
        samplerCUBE _CUBE;
        sampler2D _BumpTex;

        float4 _SpColor;
        float _SpPower;
        float _SpIntensity;

        void vert(inout appdata_full v) {
            v.vertex.y += cos(abs(v.texcoord.x * 2 - 1) * 10 + _Time.y) * 0.03;
        }

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpTex;
            float3 worldRefl;
            INTERNAL_DATA
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            
            float3 normal_1 = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex + _Time.x));
            float3 normal_2 = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex - _Time.x * 2 / 5));
            o.Normal = (normal_1 + normal_2) * 0.5;

            float4 reflection = texCUBE(_CUBE, WorldReflectionVector(IN, o.Normal));

            o.Emission = reflection * 1.05;
            o.Alpha = 1;
        }

        float4 Lightingwater(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten) {
            // Specular
            float H = normalize(lightDir + viewDir);
            float spec = pow(saturate(dot(H, s.Normal)), _SpPower);

            // Rim
            float rim = saturate(dot(s.Normal, viewDir));
            float rim1 = pow(1 - rim, 20);
            float rim2 = pow(1 - rim, 2);

            float4 final = rim1 * _LightColor0;

            return float4(final.rgb, rim2);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
