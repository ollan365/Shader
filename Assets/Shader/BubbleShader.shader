Shader "Custom/BubbleShader"
{
    Properties
    {
        _Glossiness ("Smoothness", Range(0,1)) = 1
        _Metallic ("Metallic", Range(0,1)) = 0
        
        _ChangeShapeScale("Change Shape Scale", Range(0, 0.5)) = 0.05
        _ChangeShapenSpeed("Change Shape Speed", Range(0, 0.5)) = 0.05

        _ClickPosition ("Click Position", Vector) = (0, 0, 0, 0)
        _BurstRadius("Current Burst Radius", Range(0, 1)) = 0

        _ColorChangeValue("Color Change Value", Range(1, 100)) = 5
        _ColorValue("Color Value", Range(0, 0.5)) = 0.3
        _RimValue("Rim Value", Range(1, 100)) = 1
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent"}
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard vertex:vert alpha:fade
        #pragma target 3.0

        half _Glossiness;
        half _Metallic;

        float4 _ClickPosition;
        float _BurstRadius;

        float _ChangeShapeScale;
        float _ChangeShapenSpeed;

        float _ColorChangeValue;
        float _ColorValue;
        float _RimValue;

        struct Input
        {
            float3 viewDir;
            float3 worldPos;
        };

        float GetAddPos(float pos, int offset) {
            float speed = _ChangeShapenSpeed + offset * 0.25;
            return sin(pos * 10 + _Time.y * speed) * _ChangeShapeScale;
        }

        void vert(inout appdata_full v) {
            // 버블이 일렁거려 보이도록 vertex 변경
            v.vertex.x += GetAddPos(v.vertex.x, 2);
            v.vertex.y += GetAddPos(v.vertex.y, 3);
            v.vertex.z += GetAddPos(v.vertex.z, 1);
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float3 col = sin(IN.worldPos * _ColorChangeValue) * _ColorValue + (1 - _ColorValue);
            
            float rimFactor = saturate(1 - dot(o.Normal, IN.viewDir));
            float rim = pow(rimFactor, _RimValue);
            
            // 클릭된 위치와 현재 위치 간 거리 계산
            float distanceBetween = distance(IN.worldPos, _ClickPosition.xyz);
            if (distanceBetween < _BurstRadius) {
                o.Alpha = 0;
            }
            else if(distanceBetween >= _BurstRadius && distanceBetween < _BurstRadius + 0.01) {
                o.Albedo = float3(1, 1, 1);
                o.Alpha = 1;
            }
            else {
                o.Albedo = col;
                o.Alpha = rim;
            }

            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
