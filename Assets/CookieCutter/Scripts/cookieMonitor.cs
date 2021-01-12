using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class cookieMonitor : MonoBehaviour
{
    public CookieCutterManager manager;
    public Renderer r;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        float xx = ((0+manager.cookieDoughImg.transform.localScale.x*manager.one) - (this.transform.localPosition.x+this.transform.localScale.x*manager.two))/manager.three * manager.matMultiplier;
        float zz = ((0+manager.cookieDoughImg.transform.localScale.z*manager.one) - (this.transform.localPosition.z+this.transform.localScale.z*manager.two))/manager.three * manager.matMultiplier;

        r.material.SetTextureOffset("_MainTex", new Vector2(xx, zz));
    }
}
