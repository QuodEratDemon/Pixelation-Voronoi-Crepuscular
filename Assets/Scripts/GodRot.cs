using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GodRot : MonoBehaviour {

	public Sliders xRotation;
	public Sliders yRotation;

	// Use this for initialization
	void Start () {
	}
	
	public void newXRotation(Slider slider){//float value){
		transform.eulerAngles = new Vector3(slider.value,transform.eulerAngles.y, transform.eulerAngles.z);
		xRotation.sliderText.text = slider.value.ToString ();
	}

	public void newYRotation(Slider slider){//float value){
		transform.eulerAngles = new Vector3(transform.eulerAngles.x, slider.value, transform.eulerAngles.z);
		yRotation.sliderText.text = slider.value.ToString ();
	}
}
