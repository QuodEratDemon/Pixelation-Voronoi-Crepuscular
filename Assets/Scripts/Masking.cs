using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class Masking : MonoBehaviour {

	// Use this for initialization

	public Material mat;
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	void OnRenderImage(RenderTexture source, RenderTexture dest)
	{


		Graphics.Blit(source, dest, mat);
	}
}
