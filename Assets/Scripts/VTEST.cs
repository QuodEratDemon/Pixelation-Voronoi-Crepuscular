using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VTEST : MonoBehaviour {

	// Use this for initialization
	public Material mat;
	void OnRenderImage(RenderTexture src, RenderTexture dest) {
		Graphics.Blit(src, dest, mat);
	}
}
