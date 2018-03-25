using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UIHandling : MonoBehaviour {

	Text buttonText;
	GameObject PixelizerUI;
	GameObject GodRayUI;
	bool PixelizerUIIsActive = true;
	Pixelizer pixelizer;

	// Use this for initialization
	void Start () {
		PixelizerUI = transform.parent.Find ("Pixelizer").gameObject;
		GodRayUI = transform.parent.Find ("God Ray UI").gameObject;
		buttonText = GetComponentInChildren<Text> ();
		GameObject[] mainCameras = GameObject.FindGameObjectsWithTag ("MainCamera");
		for (int i = 0; i < mainCameras.Length; i++) {
			pixelizer = mainCameras [i].GetComponent<Pixelizer> ();
			if (pixelizer != null) {
				break;
			}
		}
	}

	public void togglePixelizerUIOn(){
		if (PixelizerUIIsActive) {
			PixelizerUI.SetActive (false);
			GodRayUI.SetActive (false);
			buttonText.text = "Show UI";
		} else {
			PixelizerUI.SetActive (true);
			GodRayUI.SetActive (true);
			buttonText.text = "Hide UI";
		}
		PixelizerUIIsActive = !PixelizerUIIsActive;
	}

	public void togglePixelizerActive(){
		pixelizer.enabled = !pixelizer.enabled;
	}

}
