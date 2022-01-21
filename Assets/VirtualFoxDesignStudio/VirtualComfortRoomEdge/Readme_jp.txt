-----------------------------------------

VirtualComfortRoomEdge

© 2020 VirtualFoxDesignStudio

Ver1.0

-----------------------------------------

【内容】

質感・ライティングにこだわったVR空間向け建築ビジュアライゼーションアセットです。

・低負荷のBakedライティング。快適で軽量なライティングの空間

・展開済みライトマップUV

・PBRマテリアルによるリアルな質感

・近づいて見ても十分な解像度のリアルな質感に調整した家具


-----------------------------------------

【クイックスタートガイド】


1.新しくUnityプロジェクトを作成

・このアセットはリニア色空間で作成されているため、Edit → ProjectSetting → Player → Other Settings / Rendering → Color Space を 「Linear」に変更してからインポートすることを推奨しています

2.VirtualComfortRoomEdgeをインポート

3.Post Processing Stack V2をインポート

[2017以前の場合]
https://github.com/Unity-Technologies/PostProcessing/releases/
こちらよりダウンロードしてインストール

[2018以降の場合]
Window → PackageManager からPost Processing をInstallして下さい


4.Sceneファイルを開く

Assets/VirtualFoxDesignStudio/VirtualComfortRoomEdge/SCENE
内にあるシーンを開きます。

[VirtualComfortRoomEdge_FullLightBake]
ライトマップを細かく焼いたシーンです。オブジェクトを動かさずに使うならこちらをご利用下さい。

[VirtualComfortRoomEdge_ProbeLighting]
ライトプローブによるライティングで小物を移動してもベイクされた影が残りません。キャンバスやクッションを取り除いて使いたい場合はこちらをご利用下さい。


・シーン内にあるPost-process Volume_ForMovie はEditorOnlyでデモ用のものとなっています。ビルドした際には表示されないのでご留意下さい。

-----------------------------------------

【バージョン履歴】

Ver1.0
- 初期バージョン


-----------------------------------------
© 2020 VirtualFoxDesignStudio