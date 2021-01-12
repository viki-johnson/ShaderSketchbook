using System.Collections;
using System.Collections.Generic;
using UnityEngine;
 
public class paintbrush : MonoBehaviour
{
    public int resolution = 512;
    Texture2D whiteMap;
    public float brushSize;
    public Texture2D brushTexture;
    Vector2 stored;
    public static Dictionary<Collider, RenderTexture> paintTextures = new Dictionary<Collider, RenderTexture>();
    public CookieCutterManager ccm;

    public int layerMask;
    public GameObject cookieCutter;
    public GameObject safeArea;
    public float top, btm, lft, rht;
    public GameObject[] sa;

    void Start()
    {
        CreateClearTexture();// clear white texture to draw on
        layerMask = LayerMask.GetMask("cookieDough");

        top = safeArea.transform.position.z+safeArea.transform.localScale.z*5;
        btm = safeArea.transform.position.z-safeArea.transform.localScale.z*5;

        lft = safeArea.transform.position.x+safeArea.transform.localScale.x*5;
        rht = safeArea.transform.position.x-safeArea.transform.localScale.x*5;

        sa[0].transform.position = new Vector3(safeArea.transform.position.x, safeArea.transform.position.y, top);
        sa[1].transform.position = new Vector3(safeArea.transform.position.x, safeArea.transform.position.y, btm);

        sa[2].transform.position = new Vector3(lft, safeArea.transform.position.y, safeArea.transform.position.z);
        sa[3].transform.position = new Vector3(rht, safeArea.transform.position.y, safeArea.transform.position.z);


    }
 
    void Update() 
    {
        if(Input.GetMouseButtonUp(0) && ccm.holding){
        
 
        Debug.DrawRay(transform.position, Vector3.down * 20f, Color.magenta);
        RaycastHit hit;
        if (Physics.Raycast(cookieCutter.transform.position, Vector3.down, out hit))
        // if (Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out hit, 100, layerMask)) // delete previous and uncomment for mouse painting
        {
            if(cookieCutter.transform.position.z<top && cookieCutter.transform.position.z>btm)
            {
            Collider coll = hit.collider;
            Debug.Log(coll.name);
            if (coll != null)
            {
                if (!paintTextures.ContainsKey(coll)) // if there is already paint on the material, add to that
                {
                    Renderer rend = hit.transform.GetComponent<Renderer>();
                    paintTextures.Add(coll, getWhiteRT());
                    rend.material.SetTexture("_CookieMask", paintTextures[coll]);
                }
                if (stored != hit.lightmapCoord) // stop drawing on the same point
                {
                    stored = hit.lightmapCoord;
                    Vector2 pixelUV = hit.lightmapCoord;
                    pixelUV.y *= resolution;
                    pixelUV.x *= resolution;
                    DrawTexture(paintTextures[coll], pixelUV.x, pixelUV.y);
                }
            }
            ccm.CutCookie();
        }
        }
        }
    }
 
    void DrawTexture(RenderTexture rt, float posX, float posY)
    {
        RenderTexture.active = rt; // activate rendertexture for drawtexture;
        GL.PushMatrix();                       // save matrixes
        GL.LoadPixelMatrix(0, resolution, resolution, 0);      // setup matrix for correct size
 
        // draw brushtexture
        
        Graphics.DrawTexture(new Rect(posX - brushTexture.width / brushSize, (rt.height - posY) - brushTexture.height / brushSize, brushTexture.width / (brushSize * 0.5f), brushTexture.height / (brushSize * 0.5f)), brushTexture);
        GL.PopMatrix();
        RenderTexture.active = null;// turn off rendertexture
    }
 
    RenderTexture getWhiteRT()
    {
        RenderTexture rt = new RenderTexture(resolution, resolution, 32);
        Graphics.Blit(whiteMap, rt);
        return rt;
    }
 
    void CreateClearTexture()
    {
        whiteMap = new Texture2D(1, 1);
        whiteMap.SetPixel(0, 0, Color.black);
        whiteMap.Apply();
    }
}