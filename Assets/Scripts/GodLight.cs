using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class GodLight : MonoBehaviour {

	public Material mat;
	// Use this for initialization
	void Start () {
		
	}

	void OnRenderImage(RenderTexture src, RenderTexture dest) {
		Graphics.Blit(src, dest, mat);
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
