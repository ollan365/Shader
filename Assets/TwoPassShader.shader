Shader "Custom/TwoPassShader"
{
	Properties
	{
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_OutlineTex("Outline Texture", 2D) = "white" {}
		_OutlineColor("Outline Color", Color) = (0, 0, 0, 1)
		_OutlineWidth("Outline Width", Range(0, 1)) = 0.003
	}
	SubShader
	{
		Tags{ "RenderType" = "Opaque" }

		cull front
		// 1st pass
		CGPROGRAM
		#pragma surface surf Nolight vertex:vert noambient

		sampler2D _OutlineTex;
		float4 _OutlineColor;
		float _OutlineWidth;

		void vert(inout appdata_full v) {
			// v.vertex.xyz += v.normal.xyz * _OutlineWidth * abs(sin(_Time.y));
			v.vertex.xyz += v.normal.xyz * _OutlineWidth;
		}

		struct Input {
			float2 uv_OutlineTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o) { 
			fixed4 c = tex2D(_OutlineTex, IN.uv_OutlineTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		float4 LightingNolight(SurfaceOutput s, float3 lightDir, float atten) {
			return float4(s.Albedo, 1) * _OutlineColor;
		}
		ENDCG

		// 2nd pass
		cull back
		CGPROGRAM
		#pragma surface surf Toon noambient
		#pragma target 3.0
		sampler2D _MainTex;
		struct Input {
			float2 uv_MainTex;
		};
		void surf(Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		float4 LightingToon(SurfaceOutput s, float3 lightDir, float atten) {
			float NDotL = dot(s.Normal, lightDir) * 0.5 + 0.5;
			NDotL = NDotL * 5.0;
			NDotL = ceil(NDotL) / 5;
			float4 final;
			final.rgb = s.Albedo * NDotL * _LightColor0.rgb;
			final.a = s.Alpha;
			return final;
		}
		ENDCG
	}
	FallBack "Diffuse"
}