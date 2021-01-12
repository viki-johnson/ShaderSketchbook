using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ArrowGame : MonoBehaviour
{
    public int button, score, misses;
    public bool tappable, stir;
    public GameObject spoon;
    public float rotate, rotLerp;
    void Start()
    {
        StartCoroutine(PlayGame());
        StartCoroutine(StirBowl());
    }
    void Update()
    { 
        if(tappable){
        if (Input.GetKeyDown("up"))
        {
            tappable = false;
            if(button == 0)
            {
                hit();
            }else{
                miss();
            }
        }

        if (Input.GetKeyDown("right"))
        {
            tappable = false;
            if(button == 1)
            {
                hit();
            }else{
                miss();
            }
        }

        if (Input.GetKeyDown("down"))
        {
            tappable = false;
            if(button == 2)
            {
                hit();
            }else{
                miss();
            }
        }

        if (Input.GetKeyDown("left"))
        {
            tappable = false;
            if(button == 3)
            {
                hit();
            }else{
                miss();
            }
        }
        }
    }

    void hit(){
        Debug.Log("hit");
        score++;
        rotate += 45;
        stir = true;
        if(score == 20)
        {
            Debug.Log("complete game");
        }
    }

    void miss(){
        Debug.Log("miss");
        misses++;
        stir = false;
    }

    IEnumerator PlayGame()
    {
        while(true)
        {
            yield return new WaitForSeconds(3f);
            if(tappable)
            { 
                misses ++;
            }
            button = Random.Range(0,3);
            tappable = true;
        }
    }

    IEnumerator StirBowl()
    {
        while(true)
        {
            while(!stir)
            {
                yield return null;
            }
            rotLerp += Time.deltaTime * 150f;
            spoon.transform.localEulerAngles = new Vector3(0, rotLerp, 0);
            yield return null;
        }
    }
}
