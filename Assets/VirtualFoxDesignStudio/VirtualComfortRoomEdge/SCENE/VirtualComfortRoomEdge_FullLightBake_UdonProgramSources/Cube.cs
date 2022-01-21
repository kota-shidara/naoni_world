
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class Cube : UdonSharpBehaviour
{

    public GameObject audioSource;
    bool flag = true;

    void Start()
    {
        audioSource.SetActive(true);        
    }

    public override void Interact()
    {
        if (flag == true)
        {
            flag = false;
            audioSource.SetActive(false);
        }
        else
        {
            flag = true;
            audioSource.SetActive(true);
        }
        
    }
}
