Shader "Custom/StencilWrite_Fresnel"
{
    Properties
    {
        _FresnelColor("Fresnel Color", Color) = (1, 1, 1, 1)
        _RimIntensity("Rim Intensity", Float) = 1.5
        _FresnelPower("Fresnel Power", Float) = 2.0
        _Transparency("Transparency", Range(0.0, 1.0)) = 1.0
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "Queue" = "Geometry" }
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
                float3 normalOS : NORMAL;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float3 normalWS : TEXCOORD0;
                float3 viewDirWS : TEXCOORD1;
            };

            CBUFFER_START(UnityPerMaterial)

                half3 _FresnelColor;
                float _RimIntensity;
                float _FresnelPower;
                float _Transparency;

            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.normalWS = TransformObjectToWorldNormal(IN.normalOS);

                // Calculate the view direction in world space (from the camera to the surface)
                float3 worldPosWS = TransformObjectToWorld(IN.positionOS.xyz);
                OUT.viewDirWS = normalize(GetCameraPositionWS() - worldPosWS);
                
                return OUT;
            }
            
            half4 frag(Varyings IN) : SV_Target
            {
                half3 normalWS = normalize(IN.normalWS);
                half3 viewDirWS = normalize(IN.viewDirWS);
                half d = saturate(dot(viewDirWS, normalWS));
                half fresnel = pow(1.0 - d, _FresnelPower);
                half3 fresnelColor = _FresnelColor.rgb * fresnel * _RimIntensity;

                return half4(fresnelColor, saturate(_Transparency - d));
            }
            ENDHLSL
        }
    }
}
