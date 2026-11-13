Shader "Custom/StencilWrite_FrontObject"
{
    Properties
    {
        _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        _Transparency("Transparency", Range(0.0, 1.0)) = 1.0
    }

    SubShader
    {
        Tags { "RenderType" = "Transparent" "RenderPipeline" = "UniversalPipeline" "Queue" = "Geometry" }
        Blend SrcAlpha OneMinusSrcAlpha

        // Disable color output (so the object doesn't appear visually)
        //ColorMask 0
        ZWrite Off

        // Stencil Operations
        Stencil
        {
            Ref 1 // Set stencil reference value
            Comp Always // Always pass stencil test
            Pass Replace // Replace stencil buffer value with reference value
        }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                //float3 normalOS : NORMAL;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                //float3 normalWS : TEXCOORD0;
                //float3 viewDirWS : TEXCOORD1;
            };

            CBUFFER_START(UnityPerMaterial)

                half4 _BaseColor;
                float _Transparency;

            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);

                return OUT;
            }
            
            half4 frag(Varyings IN) : SV_Target
            {
                //half4 color = Color(0, 0, 0, 1);

                /*
                half3x3 kern = half3x3(
                    0, 0, 0,
                    0, 1, 0,
                    0, 0, 0
                );



                [unroll]
                for (int x = 0; x < 3; x++)
                {
                    [unroll]
                    for (int y = 0; y < 3; y++)
                    {
                        
                    }
                }*/

                return half4(_BaseColor.rgb, _Transparency);
            }
            ENDHLSL
        }
    }
}
