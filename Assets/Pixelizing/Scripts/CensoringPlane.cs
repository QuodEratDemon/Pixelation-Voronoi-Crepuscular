﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CensoringPlane : MonoBehaviour {

	public Camera cam;
	public Sprite sprite;
	public RenderTexture renderTexture;

	void Update(){
		//sprite.image.texture
	}

	/*Texture2D RTImage(Camera cam) {
		RenderTexture currentRT = RenderTexture.active;
		RenderTexture.active = cam.targetTexture;
		cam.Render();
		Texture2D image = new Texture2D(cam.targetTexture.width, cam.targetTexture.height);
		image.ReadPixels(new Rect(0, 0, cam.targetTexture.width, cam.targetTexture.height), 0, 0);
		image.Apply();
		RenderTexture.active = currentRT;
		return image;
	}*/
}
