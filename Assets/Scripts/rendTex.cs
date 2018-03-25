using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class rendTex : MonoBehaviour {

	// Use this for initialization
	public Camera cam;
	public Material shad;

	Vector2 resolution;


	void Start () {
		
		resolution = new Vector2(Screen.width, Screen.height);

		cam.targetTexture = new RenderTexture (Screen.width, Screen.height, 24);
		shad.SetTexture ("OcclusionMap", cam.targetTexture);
		Debug.Log("changing texture");
	}

	// Update is called once per frame
	void Update () {
		


		if (resolution.x != Screen.width || resolution.y != Screen.height) {
			resolution.x = Screen.width;
			resolution.y = Screen.height;

			cam.targetTexture = new RenderTexture (Screen.width, Screen.height, 24);
			shad.SetTexture ("OcclusionMap", cam.targetTexture);

		}

	}
}
