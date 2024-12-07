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

        _Speed("Wave Speed", Range(0.1, 80)) = 5
        _Frequency("Wave Frequency", Range(0, 5)) = 2
        _Amplitude("Wave Amplitude", Range(-1, 1)) = 1
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

        float _Speed;
        float _Frequency;
        float _Amplitude;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpTex;
            float3 worldRefl;
            float3 vertColor;
            INTERNAL_DATA
        };

        void vert(inout appdata_full v, out Input o) {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            float time = _Time * _Speed;
            float waveValueA = sin(time + v.vertex.x * _Frequency) * _Amplitude;
            v.vertex.xyz = float3(v.vertex.x, v.vertex.y + waveValueA, v.vertex.z);
            v.normal = normalize(float3(v.normal.x + waveValueA, v.normal.y, v.normal.z));
            o.vertColor = float3(waveValueA, waveValueA, waveValueA);
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            
            float3 normal_1 = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex + sin(_Time.x)));
            float3 normal_2 = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex - sin(_Time.x) * 2 / 5));
            o.Normal = (normal_1 + normal_2) * 0.5;

            float4 reflection = texCUBE(_CUBE, WorldReflectionVector(IN, o.Normal));

            o.Emission = reflection * 1.05;
            o.Alpha = 1;
        }

        float4 Lightingwater(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten) {
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
