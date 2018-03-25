using UnityEngine;


[ExecuteInEditMode]
public class RadialBlur : MonoBehaviour
{
    public Shader shader;

    public float blurStrength = 2.2f;
    public float blurWidth = 1.0f;
	public float threshold = 1.5f;
	public Texture tex;
    private Material material = null;
	public Light DLIGHT;
    private bool isOpenGL;

    private Material GetMaterial()
    {
        if (material == null)
        {
            material = new Material(shader);
            material.hideFlags = HideFlags.HideAndDontSave;
        }
        return material;
    }

    void Start()
    {
        if (shader == null)
        {
            shader = Shader.Find("FX/RadialBlur");
        }
        isOpenGL = SystemInfo.graphicsDeviceVersion.StartsWith("OpenGL");
    }

	void Updat(){

	}

    void OnRenderImage(RenderTexture source, RenderTexture dest)
    {
        //If we run in OpenGL mode, our UV coords are
        //not in 0-1 range, because of the texRECT sampler
        float ImageWidth = 1.38f;
        float ImageHeight = 1.47f;
        if (isOpenGL)
        {
            ImageWidth = source.width;

            ImageHeight = source.height;


        }


        GetMaterial().SetFloat("_BlurStrength", blurStrength);
        GetMaterial().SetFloat("_BlurWidth", blurWidth);
        GetMaterial().SetFloat("_imgHeight", ImageWidth);
        GetMaterial().SetFloat("_imgWidth", ImageHeight);
		GetMaterial ().SetTexture ("_MaskTex", tex);
		//GetMaterial().SetFloat("_LPX", DLIGHT.transform.localPosition.x);
		//GetMaterial().SetFloat("_LPY", DLIGHT.transform.localPosition.y);
		//GetMaterial().SetFloat("_LPX", Input.mousePosition.x);
		//GetMaterial().SetFloat("_LPY", Input.mousePosition.y);

        Graphics.Blit(source, dest, GetMaterial());
    }
}