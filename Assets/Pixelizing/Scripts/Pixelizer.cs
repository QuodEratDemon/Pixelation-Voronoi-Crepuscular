using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[System.Serializable]
public class CensoringTexture{
	public bool goingToTexture;
	public RenderTexture renderTexture;
}

[ExecuteInEditMode]
public class Pixelizer : MonoBehaviour {

	public Material mat;
	public Text vertSliderText;
	public Text horizSliderText;
	public float startValue;
	public CensoringTexture censoringTexture;

	void Awake(){
		mat.SetFloat ("_VertRange", startValue);
		mat.SetFloat ("_HorizRange", startValue);
		vertSliderText.text = startValue.ToString ();
		horizSliderText.text = startValue.ToString ();
	}

	void Start(){
		if(censoringTexture.goingToTexture){
			mat.SetFloat ("_TextureHeight", censoringTexture.renderTexture.height);
			mat.SetFloat ("_TextureWidth", censoringTexture.renderTexture.width);
		}
	}

	void OnRenderImage(RenderTexture src, RenderTexture dest) {
		Graphics.Blit(src, dest, mat);
	}
		
	public void newVertValue(Slider slider){//float value){
		mat.SetFloat ("_VertRange", slider.value);
		vertSliderText.text = slider.value.ToString ();
	}

	public void newHorizValue(Slider slider){//float value){
		mat.SetFloat ("_HorizRange", slider.value);
		horizSliderText.text = slider.value.ToString ();
	}
}
