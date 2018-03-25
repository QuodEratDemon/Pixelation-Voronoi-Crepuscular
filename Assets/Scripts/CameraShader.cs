using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class CameraShader : MonoBehaviour {

	// Use this for initialization
	public Material mat;
	public GameObject DLight;
	void Awake () {
		//mat.SetFloat ("_LightPositionX", DLight.transform.localPosition.x);
		//mat.SetFloat ("_LightPositionY", DLight.transform.localPosition.y);
	}

	void OnRenderImage(RenderTexture src, RenderTexture dest) {
		Graphics.Blit(src, dest, mat);
	}
	
	// Update is called once per frame
	void Update () {
		//mat.SetFloat ("_LightPositionX", DLight.transform.localPosition.x);
		//mat.SetFloat ("_LightPositionY", DLight.transform.localPosition.y);
	}
}
