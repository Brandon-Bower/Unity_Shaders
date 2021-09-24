Shader "Tests/Texture_lerp"
{
	Properties
	{
		_MainTex("Texture1", 2D) = "white" {}
		_Tex2("Texture2", 2D) = "black" {}
		_Color1("Color1", Color) = (1,1,1,1)
		_Color2("Color2", Color) = (1,1,1,1)
		_Speed("Speed", float) = 1
	}
		SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			fixed4 _Color1;
			fixed4 _Color2;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _Tex2;
			float4 _Tex2_ST;

			float _Speed;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o, o.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = lerp(tex2D(_MainTex, i.uv), tex2D(_Tex2, i.uv), sin(_Time.y * _Speed));
				col *= lerp(_Color1, _Color2, sin(_Time.y * _Speed))
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
		ENDCG
		}
	}
}
