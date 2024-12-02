Shader "Custom/BubbleShader"
{
    Properties
    {
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _ClickPosition ("Click Position", Vector) = (0, 0, 0, 0)
        _DeformStrength ("Deform Strength", Range(0, 1)) = 0.5
        _DeformRadius ("Deform Radius", Range(0.1, 1)) = 0.3
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent"}
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard vertex:vert fragment:frag alpha:fade
        #pragma target 3.0

        half _Glossiness;
        half _Metallic;
        float4 _ClickPosition;
        float _DeformStrength;
        float _DeformRadius;

        float GetAddPos(float pos, int offset) {
            float speed = 0.5 + offset * 0.25;
            return sin(pos * 10 + _Time.y * speed) * 0.02;
        }

        void vert(inout appdata_full v) {
            v.vertex.x += GetAddPos(v.vertex.x, 0);
            v.vertex.y += GetAddPos(v.vertex.y, 1);
            v.vertex.z += GetAddPos(v.vertex.z, 2);

            //// 클릭 위치와 정점 위치 간 거리 계산
            //float distanceBetween = distance(v.vertex.xyz, _ClickPosition.xyz);

            //// 거리가 일정 반경 이내일 때만 변형
            //if (distanceBetween < _DeformRadius)
            //{
            //    float deform = exp(-distanceBetween * 10) * _DeformStrength;
            //    v.vertex.z -= deform; // Z축으로 움푹 들어가게
            //}
        }

        struct Input
        {
            float3 viewDir;
            float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {

            float3 col = sin(_Time.w + IN.worldPos * 10) * 0.3 + 0.7;
            o.Albedo = col;

            float rim = dot(o.Normal, IN.viewDir);
            o.Alpha = saturate(pow(1 - rim, 1) + 0.1);

            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
