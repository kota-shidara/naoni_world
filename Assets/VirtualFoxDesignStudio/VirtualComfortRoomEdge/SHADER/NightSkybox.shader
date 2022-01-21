// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VirtualFoxDesignStudio/NightSkybox"
{
	Properties
	{
		_SkyboxMainColor("SkyboxMainColor", 2D) = "white" {}
		_MainColorTint("MainColorTint", Color) = (1,1,1,0)
		_SkyboxStar("SkyboxStar", 2D) = "white" {}
		_RotateStarSpeed("RotateStarSpeed", Float) = 0
		_SkyboxCloud("SkyboxCloud", 2D) = "white" {}
		_RotateCloudSpeed("RotateCloudSpeed", Float) = 0
		_CloudColorTint("CloudColorTint", Color) = (0,0.9586205,1,0)
		_CloudEmission("CloudEmission", Float) = 0
		_StarEmission("StarEmission", Float) = 0

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityStandardBRDF.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
#endif
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};

			uniform sampler2D _SkyboxMainColor;
			uniform sampler2D _SkyboxStar;
			uniform float _RotateStarSpeed;
			uniform float _StarEmission;
			uniform sampler2D _SkyboxCloud;
			uniform float _RotateCloudSpeed;
			uniform float _CloudEmission;
			uniform float4 _CloudColorTint;
			uniform float4 _MainColorTint;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
#endif
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = Unity_SafeNormalize( ase_worldViewDir );
				float2 appendResult31 = (float2(ase_worldViewDir.x , ase_worldViewDir.z));
				float2 break32 = appendResult31;
				float dotResult27 = dot( ase_worldViewDir , float3(0,1,0) );
				float2 appendResult12 = (float2((0.0 + (atan2( break32.x , break32.y ) - -UNITY_PI) * (1.0 - 0.0) / (UNITY_PI - -UNITY_PI)) , (0.0 + (acos( dotResult27 ) - 0.0) * (1.0 - 0.0) / (UNITY_PI - 0.0))));
				float mulTime79 = _Time.y * 0.1;
				float2 appendResult77 = (float2(( mulTime79 * _RotateStarSpeed ) , 0.0));
				float mulTime81 = _Time.y * 0.1;
				float2 appendResult84 = (float2(( mulTime81 * _RotateCloudSpeed ) , 0.0));
				
				
				finalColor = ( ( ( tex2Dlod( _SkyboxMainColor, float4( appendResult12, 0, 0.0) ) + ( tex2Dlod( _SkyboxStar, float4( frac( ( appendResult12 + appendResult77 ) ), 0, 0.0) ) * _StarEmission ) + ( tex2D( _SkyboxCloud, frac( ( appendResult12 + appendResult84 ) ) ) * ( _CloudEmission * unity_ColorSpaceDouble ) * _CloudColorTint ) ) * _MainColorTint ) * unity_ColorSpaceDouble );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18000
1920;764;1920;1058;1096.083;466.3258;2.167862;True;False
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;5;-2213.563,-398.1374;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;28;-1813.728,-222.0124;Float;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;False;0;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;31;-1897.98,-576.4096;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;32;-1583.98,-577.4096;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DotProductOpNode;27;-1086.633,-358.102;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;41;-1099.388,-185.9242;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-205.5103,796.3192;Inherit;False;Property;_RotateCloudSpeed;RotateCloudSpeed;5;0;Create;True;0;0;False;0;0;-0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;81;-272.0989,558.6262;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ACosOpNode;29;-960.2905,-357.9634;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-213.1962,139.3025;Inherit;False;Property;_RotateStarSpeed;RotateStarSpeed;3;0;Create;True;0;0;False;0;0;0.002;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;79;-234.9904,17.04094;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;42;-991.3877,-452.9242;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;4;-1320.912,-576.6427;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;44;-654.3875,-79.92422;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;3.13;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;6;-782.7109,-501.7427;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-3.141593;False;2;FLOAT;3.141593;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;10.75525,5.415222;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-90.09885,586.6262;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;77;241.6693,-24.65643;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;-331.0675,-374.3639;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;84;140.8152,556.5545;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;388.6693,-82.65643;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;85;287.8152,498.5545;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FractNode;86;483.8152,428.5545;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FractNode;78;519.6693,-75.65643;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;45;288.5782,-266.5097;Inherit;False;Constant;_mipmapOff;mipmapOff;4;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;598.2867,933.1848;Inherit;False;Property;_CloudEmission;CloudEmission;7;0;Create;True;0;0;False;0;0;1.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorSpaceDouble;107;224,1424;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;65;715.3181,472.8174;Inherit;True;Property;_SkyboxCloud;SkyboxCloud;4;0;Create;True;0;0;False;0;-1;None;29b2377d49326e04f926d7c6ff0f38a3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;39;710.6592,-105.5277;Inherit;True;Property;_SkyboxStar;SkyboxStar;2;0;Create;True;0;0;False;0;-1;None;54aaeb41243efe24f84e7ad18a87a1fc;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;70;807.6919,1149.79;Inherit;False;Property;_CloudColorTint;CloudColorTint;6;0;Create;True;0;0;False;0;0,0.9586205,1,0;0,0.2621677,0.6886792,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;100;1147.543,143.9929;Inherit;False;Property;_StarEmission;StarEmission;8;0;Create;True;0;0;False;0;0;0.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;853.0165,921.7967;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;26;707.5434,-402.4078;Inherit;True;Property;_SkyboxMainColor;SkyboxMainColor;0;0;Create;True;0;0;False;0;-1;None;cea887e6fe781214cbcd6c28d380e596;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;1058.963,843.9892;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;1492.718,49.03178;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;97;2285.651,301.8284;Inherit;False;Property;_MainColorTint;MainColorTint;1;0;Create;True;0;0;False;0;1,1,1,0;0.6509434,0.6509434,0.6509434,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;38;2321.232,165.7223;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;2651.012,171.1058;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorSpaceDouble;105;2270.036,693.7426;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;2889.17,197.3755;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;3055.21,208.3656;Float;False;True;-1;2;ASEMaterialInspector;100;1;VirtualFoxDesignStudio/NightSkybox;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;0
WireConnection;31;0;5;1
WireConnection;31;1;5;3
WireConnection;32;0;31;0
WireConnection;27;0;5;0
WireConnection;27;1;28;0
WireConnection;29;0;27;0
WireConnection;42;0;41;0
WireConnection;4;0;32;0
WireConnection;4;1;32;1
WireConnection;44;0;29;0
WireConnection;44;2;41;0
WireConnection;6;0;4;0
WireConnection;6;1;42;0
WireConnection;6;2;41;0
WireConnection;80;0;79;0
WireConnection;80;1;34;0
WireConnection;83;0;81;0
WireConnection;83;1;82;0
WireConnection;77;0;80;0
WireConnection;12;0;6;0
WireConnection;12;1;44;0
WireConnection;84;0;83;0
WireConnection;76;0;12;0
WireConnection;76;1;77;0
WireConnection;85;0;12;0
WireConnection;85;1;84;0
WireConnection;86;0;85;0
WireConnection;78;0;76;0
WireConnection;65;1;86;0
WireConnection;39;1;78;0
WireConnection;39;2;45;0
WireConnection;108;0;68;0
WireConnection;108;1;107;0
WireConnection;26;1;12;0
WireConnection;26;2;45;0
WireConnection;67;0;65;0
WireConnection;67;1;108;0
WireConnection;67;2;70;0
WireConnection;101;0;39;0
WireConnection;101;1;100;0
WireConnection;38;0;26;0
WireConnection;38;1;101;0
WireConnection;38;2;67;0
WireConnection;96;0;38;0
WireConnection;96;1;97;0
WireConnection;104;0;96;0
WireConnection;104;1;105;0
WireConnection;0;0;104;0
ASEEND*/
//CHKSM=DFAEA60BF370AB925F1CB28C0F1E0F31F715577D