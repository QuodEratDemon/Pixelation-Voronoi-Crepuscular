using UnityEngine;

public class VoronoiRandom : MonoBehaviour {

    private float minX;
    private float maxX;
    private float minY;
    private float maxY;
    private float minZ;
    private float maxZ;

    public int length;

    public Vector4[] points;
    public Vector4[] colours;

    private Material material;
    private Vector3 obj;

    void Start () {
        material = GetComponent<Renderer>().material;
        obj = GetComponent<Renderer>().bounds.size;

        //Points scale with size of object it's attached to
        minX = obj.x * -1f;
        maxX = obj.x * 1f;
        minY = obj.y * -1f;
        maxY = obj.y * +1f;
        minZ = obj.z * -1f;
        maxZ = obj.z * +1f;

        points = new Vector4[length];
        colours = new Vector4[length];

        for (int i = 0; i < length; i ++)
        {
            //Set and populate points for voronoi diagram
            points[i] = new Vector3
            (
                transform.position.x + Random.Range(minX, maxX),
                transform.position.y + Random.Range(minY, maxY),
                transform.position.z + Random.Range(minZ, maxZ)
            );
        }
        //Pass the values to the shader code
        material.SetVectorArray("_Points", points);
        material.SetInt("_Length", length);
    }


    [Range(0, 1)]
    public float amount = 0.5f; //Amount of randomness
    void Update()
    {
        if (amount == 0)
            return;
        for (int i = 0; i < length; i++)
        {
            //Animate the voronoi cells using perlin noise
            points[i].x += (Mathf.Sin(Mathf.PerlinNoise(Time.time, amount)*points[i].y) * (0.01f));
            points[i].y += (Mathf.Cos(Mathf.PerlinNoise(amount, Time.time)*points[i].x) * (0.01f));
            points[i].z += (Mathf.Cos(Mathf.PerlinNoise(Time.time, Time.time)*points[i].x) * (0.01f));
        }
        // Shader
        material.SetVectorArray("_Points", points);
        material.SetFloat("noise", Mathf.PerlinNoise(Time.time, Time.time));
    }
}
