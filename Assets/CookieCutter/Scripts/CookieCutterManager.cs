using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CookieCutterManager : MonoBehaviour
{
   public paintbrush brush;
   public CookieCutter[] shapes;
   public CookieCutter currentShape;
   public bool holding;

   public GameObject cookiePrefab, cookieContainer;
   public List<GameObject> cookieList;
   public GameObject cookieDoughImg;
//    public GameObject pointO;
   public GameObject[] cookieEndPoints;

   public int cookies;
   public float matMultiplier;

   public float one,two,three; //25,5,10


   // tiling = doughscale*cookiescale

    void Start()
    {
        foreach(CookieCutter c in shapes){
            c.OnStartDrag += PickUpCookieCutter;
        }
    }

    public void PickUpCookieCutter(){
        foreach(CookieCutter c in shapes){
            if(c.dragging){
                holding = true;
                brush.brushTexture = c.cookieShape;
                brush.cookieCutter = c.gameObject;
                currentShape = c;
            }
        }
    }

    public void CutCookie(){
        holding = false;
        Quaternion rotation = Quaternion.Euler(0, 180, 0);
        GameObject go = GameObject.Instantiate(cookiePrefab, currentShape.transform.position, rotation);
        // Debug.Log(go.transform.localScale.z + "  " + cookieDoughImg.transform.localScale.z);
        float cookiescale = go.transform.localScale.z;

        
        cookieList.Add(go);
        go.transform.parent = cookieDoughImg.transform; /// what the fuck is happening here?
        Renderer r = go.GetComponent<Renderer>();
        r.material.SetTexture("_AlphaTex", currentShape.cookieShape);

        float xx = ((0+cookieDoughImg.transform.localScale.x*one) - (go.transform.localPosition.x+go.transform.localScale.x*two))/three * matMultiplier;
        float zz = ((0+cookieDoughImg.transform.localScale.z*one) - (go.transform.localPosition.z+go.transform.localScale.z*two))/three * matMultiplier;

        r.material.SetTextureOffset("_MainTex", new Vector2(xx, zz));



        float sc = cookiescale/cookieDoughImg.transform.localScale.z;
        r.material.mainTextureScale = new Vector2(sc,sc);

        go.transform.parent = cookieContainer.transform;
        cookies++;
        if(cookies == cookieEndPoints.Length){
            StartCoroutine(EndCookies());
        }
    }
    public IEnumerator EndCookies(){
        yield return new WaitForSeconds(0.5f);
        Debug.Log("cookies end");
        for(int q = 0; q<cookieEndPoints.Length; q++){
            Debug.Log("cookies end " + q);
            StartCoroutine(MoveCookie(q));
            yield return new WaitForSeconds(0.2f);
        }
    }

    public IEnumerator MoveCookie(int c){
        Vector3 start = cookieList[c].transform.position;
        Vector3 end = cookieEndPoints[c].transform.position;

        float percentage = 0;

        while(percentage<1){
            percentage += Time.deltaTime * 2.5f;
            cookieList[c].transform.position = Vector3.Lerp(start, end, percentage);
            yield return null;
        }
    }
}
