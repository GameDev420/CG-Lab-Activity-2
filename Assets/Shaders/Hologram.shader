Shader "Custom/Hologram"
{
    Properties
    {
        _MainTex("Main Tex", 2D) = "white" {}
        [HDR] _LineColor("Line Color", Color) = (1, 1, 1, 1)
        [HDR] _FresnelColor("Fresnel Color", Color) = (0, 0.8, 1, 1)
        _RimIntensity("Rim Intensity", Float) = 1.5
        _FresnelPower("Fresnel Power", Range(1, 10)) = 2.0
        _LineSpeed("Line Speed", Float) = 1.0
        _LineFrequency("Line Frequency", Float ) = 10.0
        _Transparency("Transparency", Range(0.0, 1.0)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType" = "Transparent" "RenderPipeline" = "UniversalPipeline" "Queue" = "Transparent" }

        // Transparency Blending
        Blend SrcAlpha OneMinusSrcAlpha

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
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float3 normalWS : TEXCOORD1;
                float3 viewDirWS : TEXCOORD2;
                float2 uv : TEXCOORD0;
            };

            // Material properties
            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);
            float4 _LineColor;
            float4 _FresnelColor;
            float _RimIntensity;
            float _FresnelPower;
            float _LineSpeed;
            float _LineFrequency;
            float _Transparency;

            // No CBUFFER ?
            //CBUFFER_START(UnityPerMaterial)
            //CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.normalWS = normalize(TransformObjectToWorldNormal(IN.normalOS));
                OUT.viewDirWS = normalize(GetWorldSpaceViewDir(IN.positionOS.xyz));
                OUT.uv = IN.uv;
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 texColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);

                // Fresnel effect (rim lighting)
                half3 normalWS = normalize(IN.normalWS);
                half3 viewDirWS = normalize(IN.viewDirWS);
                half fresnel = pow(1.0 - saturate(dot(viewDirWS, normalWS)), _FresnelPower);
                half3 fresnelColor = _FresnelColor.rgb * fresnel * _RimIntensity;

                // Scrolling lines effect
                float lineValue = sin(IN.uv.y * _LineFrequency + _Time.y * _LineSpeed);
                half3 lineColor = _LineColor.rgb * step(0.5, lineValue); // creates sharp scan lines

                // Combine final texture, fresnel rim, and scan lines
                half3 finalColor = texColor.rgb + fresnelColor + lineColor;

                return half4(finalColor, _Transparency);
            }
            ENDHLSL
        }
    }
}
