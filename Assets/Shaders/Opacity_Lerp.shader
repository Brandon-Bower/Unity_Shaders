// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Based on gradient code by jRocket, found at: https://forum.unity.com/threads/simple-vertex-color-gradient.226263/
Shader "Tests/AlphaLerp" {
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_Alpha1("Top Alpha", Range(0.0,1.0)) = 1.0
		_Alpha2("Bottom Alpha", Range(0.0,1.0)) = 1.0
		_Scale("Scale", float) = 1
	}

		SubShader{
			Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" }
			LOD 100

			ZWrite OFF
			Blend SrcAlpha OneMinusSrcAlpha

			Pass{
				CGPROGRAM
				#pragma vertex vert  
				#pragma fragment frag
				#include "UnityCG.cginc"

				fixed4 _Color;
				float _Alpha1;
				float _Alpha2;
				fixed  _Scale;

				struct v2f {
					float4 pos : SV_POSITION;
					fixed4 col : COLOR;
				};

				v2f vert(appdata_full v)
				{
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f, o);
					o.pos = UnityObjectToClipPos(v.vertex);
					//o.col = _Color;
					o.col.a = max(0, lerp(_Alpha1, _Alpha2, v.vertex.y * _Scale));
					return o;
				}


				float4 frag(v2f i) : COLOR{
					float4 c = _Color;
					c.a = i.col.a;
					return c;
			}
			ENDCG
		}
	}
}