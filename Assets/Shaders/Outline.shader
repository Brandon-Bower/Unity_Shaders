Shader "Tests/Outline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color1 ("Color", Color) = (1,1,1,1)
        _Color2 ("Outline Color", Color) = (1,0,0,1)
        _Weight ("LineWeight", Range(1,1.2)) = 1.05
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Pass // Outline
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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            fixed4 _Color2;
            float _Weight;

            v2f vert(appdata v)
            {
                v2f o;
                v.vertex.xyz += v.normal.xyz * _Weight * -1;
                o.vertex = UnityObjectToClipPos(v.vertex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
            // apply fog
            UNITY_APPLY_FOG(i.fogCoord, _Color2);
            return _Color2;
        }
        ENDCG
    }
        Pass // object
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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color1;
            float _Weight;

            v2f vert (appdata v)
            {
                v2f o;
                //v.vertex.xyz += v.normal.xyz * _Weight;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col * _Color1;
            }
            ENDCG
        }
    }
}
