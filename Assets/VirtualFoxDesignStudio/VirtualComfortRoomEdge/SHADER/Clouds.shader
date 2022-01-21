// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VirtualFoxDesignStudio/Clouds"
{
	Properties
	{
		_cloud("cloud", 2D) = "white" {}
		_CloudPower("CloudPower", Range( 0.1 , 3)) = 0
		_CloudBaseColor("CloudBaseColor", Color) = (0.3235294,0.3235294,0.3235294,0.647)
		_CloudEmissionColor("CloudEmissionColor", Color) = (0.3235294,0.3235294,0.3235294,0.647)
		_CloudEmissionPower("CloudEmissionPower", Range( 0.1 , 10)) = 0
		_EmissionMultiplier("EmissionMultiplier", Range( 0.0001 , 1)) = 0
		_MoveMultiplierX("MoveMultiplierX", Float) = 0
		_MoveMultiplierY("MoveMultiplierY", Float) = 0
		_TimeMultiplierX("TimeMultiplierX", Float) = 0
		_TimeMultiplierY("TimeMultiplierY", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _TimeMultiplierX;
		uniform float _MoveMultiplierX;
		uniform float _TimeMultiplierY;
		uniform float _MoveMultiplierY;
		uniform float4 _CloudBaseColor;
		uniform sampler2D _cloud;
		uniform float4 _cloud_ST;
		uniform float _CloudPower;
		uniform float _CloudEmissionPower;
		uniform float _EmissionMultiplier;
		uniform float4 _CloudEmissionColor;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 transform10 = mul(unity_ObjectToWorld,float4(0,0,0,1));
			float4 transform57 = mul(unity_ObjectToWorld,float4(0,0,0,1));
			float3 appendResult4 = (float3(( sin( ( transform10.z + ( _Time.y * _TimeMultiplierX ) ) ) * _MoveMultiplierX ) , ( cos( ( transform57.z + ( _Time.y * _TimeMultiplierY ) ) ) * _MoveMultiplierY ) , 0.0));
			v.vertex.xyz += appendResult4;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_cloud = i.uv_texcoord * _cloud_ST.xy + _cloud_ST.zw;
			float4 tex2DNode1 = tex2D( _cloud, uv_cloud );
			float4 temp_cast_0 = (_CloudPower).xxxx;
			float4 temp_cast_1 = (_CloudEmissionPower).xxxx;
			o.Emission = ( ( ( _CloudBaseColor * pow( tex2DNode1 , temp_cast_0 ) ) + ( ( pow( tex2DNode1 , temp_cast_1 ) * ( _EmissionMultiplier * unity_ColorSpaceDouble ) ) * _CloudEmissionColor ) ) * unity_ColorSpaceDouble ).rgb;
			o.Alpha = ( tex2DNode1.a * _CloudBaseColor.a );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
1904;776;1906;956;2516.908;564.3289;1.6;True;False
Node;AmplifyShaderEditor.CommentaryNode;52;-2332.655,-538.2807;Inherit;False;976.0005;565;CosWave;9;61;59;58;57;56;55;54;53;62;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;51;-2334.749,-1143.505;Inherit;False;976.0005;565;SinWave;9;2;6;12;8;10;13;9;7;5;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;1;-444.1541,89.69824;Inherit;True;Property;_cloud;cloud;0;0;Create;True;0;0;False;0;-1;28e99c835d78af74aa94fc5056206c87;28e99c835d78af74aa94fc5056206c87;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;55;-2282.655,-488.2808;Inherit;False;Constant;_Vector1;Vector 1;3;0;Create;True;0;0;False;0;0,0,0,1;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-2053.649,-710.4909;Inherit;False;Property;_TimeMultiplierX;TimeMultiplierX;8;0;Create;True;0;0;False;0;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;2;-2100.748,-851.5049;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;26.43216,633.7833;Inherit;False;Property;_EmissionMultiplier;EmissionMultiplier;5;0;Create;True;0;0;False;0;0;0.0001;0.0001;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorSpaceDouble;73;162.2166,872.2338;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;53;-2098.654,-246.2808;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-2057.527,-102.2807;Inherit;False;Property;_TimeMultiplierY;TimeMultiplierY;9;0;Create;True;0;0;False;0;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;12;-2284.749,-1093.505;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;False;0;0,0,0,1;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;67;-275.1409,497.0687;Inherit;False;Property;_CloudEmissionPower;CloudEmissionPower;4;0;Create;True;0;0;False;0;0;4;0.1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-288.4701,318.0342;Inherit;False;Property;_CloudPower;CloudPower;1;0;Create;True;0;0;False;0;0;3;0.1;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1888.748,-858.5049;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;330.3904,612.4027;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;66;177.7139,408.2186;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;10;-2095.748,-1092.505;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-1886.655,-253.2807;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;57;-2093.654,-487.2808;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;58;-1806.655,-431.2808;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-1808.748,-1036.505;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;8.971939,-503.7531;Inherit;False;Property;_CloudBaseColor;CloudBaseColor;2;0;Create;True;0;0;False;0;0.3235294,0.3235294,0.3235294,0.647;0.6470588,0.8247465,1,0.359;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;72;555.1151,506.9375;Inherit;False;Property;_CloudEmissionColor;CloudEmissionColor;3;0;Create;True;0;0;False;0;0.3235294,0.3235294,0.3235294,0.647;0,0.7931032,1,0.359;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;620.8966,343.8948;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;26;45.98053,95.66719;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;860.2368,312.5212;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SinOpNode;7;-1727.748,-859.5049;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;62;-1693.593,-271.7885;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;943.2064,-170.9608;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1759.748,-693.5051;Inherit;False;Property;_MoveMultiplierX;MoveMultiplierX;6;0;Create;True;0;0;False;0;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-1757.655,-88.28075;Inherit;False;Property;_MoveMultiplierY;MoveMultiplierY;7;0;Create;True;0;0;False;0;0;10.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1527.749,-860.5049;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;1037.641,149.1008;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-1525.655,-255.2807;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorSpaceDouble;75;1258.14,815.7405;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;4;-37.24915,-293.3311;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;1703.067,-49.45058;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;529.3035,-204.7164;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1919.059,-167.9819;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;VirtualFoxDesignStudio/Clouds;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;2;0
WireConnection;8;1;6;0
WireConnection;74;0;65;0
WireConnection;74;1;73;0
WireConnection;66;0;1;0
WireConnection;66;1;67;0
WireConnection;10;0;12;0
WireConnection;56;0;53;0
WireConnection;56;1;54;0
WireConnection;57;0;55;0
WireConnection;58;0;57;3
WireConnection;58;1;56;0
WireConnection;13;0;10;3
WireConnection;13;1;8;0
WireConnection;64;0;66;0
WireConnection;64;1;74;0
WireConnection;26;0;1;0
WireConnection;26;1;27;0
WireConnection;28;0;64;0
WireConnection;28;1;72;0
WireConnection;7;0;13;0
WireConnection;62;0;58;0
WireConnection;17;0;16;0
WireConnection;17;1;26;0
WireConnection;5;0;7;0
WireConnection;5;1;9;0
WireConnection;69;0;17;0
WireConnection;69;1;28;0
WireConnection;61;0;62;0
WireConnection;61;1;59;0
WireConnection;4;0;5;0
WireConnection;4;1;61;0
WireConnection;76;0;69;0
WireConnection;76;1;75;0
WireConnection;25;0;1;4
WireConnection;25;1;16;4
WireConnection;0;2;76;0
WireConnection;0;9;25;0
WireConnection;0;11;4;0
ASEEND*/
//CHKSM=58BBAD25B00B61D39FA24E1D7D92E2D2603E8347