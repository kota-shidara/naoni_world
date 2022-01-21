// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VirtualFoxDesignStudio/ClothShader"
{
	Properties
	{
		_UV2_AO("UV2_AO", 2D) = "white" {}
		[Normal]_UV2_Normal("UV2_Normal", 2D) = "bump" {}
		_Albedo("Albedo", 2D) = "white" {}
		_MetalicSmoothness("MetalicSmoothness", 2D) = "black" {}
		[Normal]_NormalMap("NormalMap", 2D) = "bump" {}
		_NormalPower_Multiplier("NormalPower_Multiplier", Float) = 1
		_AO_Multiplier("AO_Multiplier", Float) = 1
		[Toggle]_BackFaceTintEnable("BackFaceTintEnable", Float) = 1
		_BackFaceTint("BackFaceTint", Color) = (0,0,0,0)
		[Toggle]_BackFaceSmoothnessEnable("BackFaceSmoothnessEnable", Float) = 1
		_BackFaceSmoothness("BackFaceSmoothness", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Off
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
			half ASEVFace : VFACE;
		};

		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _NormalPower_Multiplier;
		uniform sampler2D _UV2_Normal;
		uniform float4 _UV2_Normal_ST;
		uniform float _BackFaceTintEnable;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _BackFaceTint;
		uniform sampler2D _MetalicSmoothness;
		uniform float4 _MetalicSmoothness_ST;
		uniform float _BackFaceSmoothnessEnable;
		uniform float _BackFaceSmoothness;
		uniform sampler2D _UV2_AO;
		uniform float4 _UV2_AO_ST;
		uniform float _AO_Multiplier;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv0_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float2 uv1_UV2_Normal = i.uv2_texcoord2 * _UV2_Normal_ST.xy + _UV2_Normal_ST.zw;
			float3 tex2DNode8 = UnpackNormal( tex2D( _UV2_Normal, uv1_UV2_Normal ) );
			float3 break26 = ( _NormalPower_Multiplier * tex2DNode8 );
			float3 appendResult27 = (float3(break26.x , break26.y , tex2DNode8.b));
			float3 normalizeResult24 = normalize( appendResult27 );
			o.Normal = BlendNormals( UnpackNormal( tex2D( _NormalMap, uv0_NormalMap ) ) , normalizeResult24 );
			float2 uv0_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 tex2DNode1 = tex2D( _Albedo, uv0_Albedo );
			float4 switchResult29 = (((i.ASEVFace>0)?(tex2DNode1):(( tex2DNode1 * _BackFaceTint ))));
			o.Albedo = (( _BackFaceTintEnable )?( switchResult29 ):( tex2DNode1 )).rgb;
			float2 uv0_MetalicSmoothness = i.uv_texcoord * _MetalicSmoothness_ST.xy + _MetalicSmoothness_ST.zw;
			float4 tex2DNode2 = tex2D( _MetalicSmoothness, uv0_MetalicSmoothness );
			o.Metallic = tex2DNode2.r;
			float switchResult38 = (((i.ASEVFace>0)?(tex2DNode2.a):(( tex2DNode2.a * _BackFaceSmoothness ))));
			o.Smoothness = (( _BackFaceSmoothnessEnable )?( switchResult38 ):( tex2DNode2.a ));
			float2 uv1_UV2_AO = i.uv2_texcoord2 * _UV2_AO_ST.xy + _UV2_AO_ST.zw;
			o.Occlusion = ( tex2D( _UV2_AO, uv1_UV2_AO ) * _AO_Multiplier ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17900
1927;1100;1906;1004;850.7882;395.0018;1;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-905.6738,740.7894;Inherit;False;1;8;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;8;-448.5182,719.4589;Inherit;True;Property;_UV2_Normal;UV2_Normal;1;1;[Normal];Create;True;0;0;False;0;-1;None;31a6bf9fb6c92eb458145ddba0e1ad11;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-383.3625,646.28;Inherit;False;Property;_NormalPower_Multiplier;NormalPower_Multiplier;5;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-874,171;Inherit;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-882,3;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-57.33271,667.5043;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;26;188.9906,637.2554;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SamplerNode;2;-448,216;Inherit;True;Property;_MetalicSmoothness;MetalicSmoothness;3;0;Create;True;0;0;False;0;-1;None;4a4e576a7f57a734199515c0aa3bd376;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-454,-3;Inherit;True;Property;_Albedo;Albedo;2;0;Create;True;0;0;False;0;-1;None;ec272fa12d041144ba83956de6c7d999;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;32;-259.9297,-340.2904;Inherit;False;Property;_BackFaceTint;BackFaceTint;8;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;39;-148.1938,418.0864;Inherit;False;Property;_BackFaceSmoothness;BackFaceSmoothness;10;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;9.729767,-237.5781;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;27;472.5498,757.9933;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-886.5895,941.916;Inherit;False;1;9;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-869,334;Inherit;False;0;3;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;90.80621,426.0864;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;24;606.0656,675.099;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;3;-446,451;Inherit;True;Property;_NormalMap;NormalMap;4;1;[Normal];Create;True;0;0;False;0;-1;None;afeb8239710e6524e876f34d9cfabfd7;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-437.1371,938.5372;Inherit;True;Property;_UV2_AO;UV2_AO;0;0;Create;True;0;0;False;0;-1;None;81ce7d1c228a96e419067a641c07a343;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwitchByFaceNode;29;281.525,-184.0893;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-25.53917,1128.148;Inherit;False;Property;_AO_Multiplier;AO_Multiplier;6;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;38;206.8062,346.0864;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;30;574.7873,-168.4682;Inherit;False;Property;_BackFaceTintEnable;BackFaceTintEnable;7;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;19;567.3669,445.6754;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;76.96382,907.6693;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;37;444.8062,201.0864;Inherit;False;Property;_BackFaceSmoothnessEnable;BackFaceSmoothnessEnable;9;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1020.828,-40.8842;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;VirtualFoxDesignStudio/ClothShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;1;11;0
WireConnection;28;0;23;0
WireConnection;28;1;8;0
WireConnection;26;0;28;0
WireConnection;2;1;7;0
WireConnection;1;1;4;0
WireConnection;31;0;1;0
WireConnection;31;1;32;0
WireConnection;27;0;26;0
WireConnection;27;1;26;1
WireConnection;27;2;8;3
WireConnection;40;0;2;4
WireConnection;40;1;39;0
WireConnection;24;0;27;0
WireConnection;3;1;6;0
WireConnection;9;1;12;0
WireConnection;29;0;1;0
WireConnection;29;1;31;0
WireConnection;38;0;2;4
WireConnection;38;1;40;0
WireConnection;30;0;1;0
WireConnection;30;1;29;0
WireConnection;19;0;3;0
WireConnection;19;1;24;0
WireConnection;14;0;9;0
WireConnection;14;1;15;0
WireConnection;37;0;2;4
WireConnection;37;1;38;0
WireConnection;0;0;30;0
WireConnection;0;1;19;0
WireConnection;0;3;2;1
WireConnection;0;4;37;0
WireConnection;0;5;14;0
ASEEND*/
//CHKSM=01C737DF191AB191DD4A7FECD29AFEF5AA715EDF