﻿using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UdonSharp;
using UnityEditor;
using UnityEditor.Build;
using UnityEditor.Build.Reporting;
using UnityEngine;
using UnityEngine.SceneManagement;
using VRC.Udon;

namespace HoshinoLabs.IwaSync3
{
    internal class IwaSync3BuildProcessor : IProcessSceneWithReport
    {
        public int callbackOrder => 0;

        public void OnProcessScene(Scene scene, BuildReport report)
        {
            var iwaSync = FindObjectsOfType<IwaSync3>(true);
            var desktopBar = FindObjectsOfType<DesktopBar>(true);
            var playlist = FindObjectsOfType<Playlist>(true);
            var queuelist = FindObjectsOfType<Queuelist>(true);
            var screen = FindObjectsOfType<Screen>(true);
            var speaker = FindObjectsOfType<Speaker>(true);

            ApplyModifiedProperties<IwaSync3Editor>(iwaSync);
            ApplyModifiedProperties<DesktopBarEditor>(desktopBar);
            ApplyModifiedProperties<PlaylistEditor>(playlist);
            ApplyModifiedProperties<QueuelistEditor>(queuelist);
            ApplyModifiedProperties<ScreenEditor>(screen);
            ApplyModifiedProperties<SpeakerEditor>(speaker);

            ApplyIsolate(iwaSync.SelectMany(x => x.GetUdonComponentsInChildren<Udon.IwaSync3.VideoCore>(true)));
            ApplyIsolate(iwaSync.SelectMany(x => x.GetUdonComponentsInChildren<Udon.IwaSync3.VideoController>(true)));
            ApplyIsolate(iwaSync.SelectMany(x => x.GetUdonComponentsInChildren<Udon.IwaSync3.IwaSync3>(true)));
            ApplyIsolate(desktopBar.SelectMany(x => x.GetUdonComponentsInChildren<Udon.IwaSync3.DesktopBar>(true)));
            ApplyIsolate(playlist.SelectMany(x => x.GetUdonComponentsInChildren<Udon.IwaSync3.Playlist>(true)));
            ApplyIsolate(queuelist.SelectMany(x => x.GetUdonComponentsInChildren<Udon.IwaSync3.Queuelist>(true)));
            ApplyIsolate(screen.SelectMany(x => x.GetUdonComponentsInChildren<Udon.IwaSync3.VideoScreen>(true)));
            ApplyIsolate(speaker.SelectMany(x => x.GetComponentsInChildren<AudioSource>(true)));

            Cleaning(iwaSync);
            Cleaning(desktopBar);
            Cleaning(playlist);
            Cleaning(queuelist);
            Cleaning(screen);
            Cleaning(speaker);
        }

        T[] FindObjectsOfType<T>(bool includeInactive) where T : Component
        {
            return Resources.FindObjectsOfTypeAll<T>()
                .Where(x => AssetDatabase.GetAssetOrScenePath(x).EndsWith(".unity"))
                .Where(x => includeInactive || x.gameObject.activeInHierarchy)
                .ToArray();
        }

        void ApplyModifiedProperties<T>(Component[] objs)
            where T : IwaSync3EditorBase
        {
            foreach (var x in objs)
            {
                var editor = (T)Editor.CreateEditor(x, typeof(T));
                editor.ApplyModifiedProperties();
                GameObject.DestroyImmediate(editor);
            }
        }

        void ApplyIsolate<T>(IEnumerable<T> objs)
            where T : Behaviour
        {
            foreach (var x in objs)
            {
                x.gameObject.SetActive(true);
                x.enabled = true;
                for (var i = x.transform.childCount - 1; 0 <= i; i--)
                {
                    var child = x.transform.GetChild(i);
                    if (child.GetComponentInChildren<UdonBehaviour>() == null)
                    {
                        child.SetParent(x.transform.parent, false);
                        child.SetSiblingIndex(x.transform.GetSiblingIndex());
                    }
                }
                x.transform.SetParent(null, true);
            }
        }

        void Cleaning<T>(IEnumerable<T> objs)
            where T : MonoBehaviour
        {
            foreach (var x in objs)
                GameObject.DestroyImmediate(x);
        }
    }
}
