using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Draggable : MonoBehaviour
{

    private Vector3 screenPoint;
    private Vector3 offset;
    public Vector3 curPosition;
    public float freezeOffset;

    public bool freezeX, freezeY, freezeZ;
    public bool dragging;   

    public delegate void startDrag();
    public event startDrag OnStartDrag;
    void OnMouseDown()
    {
        screenPoint = Camera.main.WorldToScreenPoint(transform.position);
        offset =  transform.localPosition - Camera.main.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y,screenPoint.z));
        dragging = true;
        OnStartDrag?.Invoke();
    }

    void OnMouseDrag()
    {
        Vector3 curScreenPoint = new Vector3(Input.mousePosition.x, Input.mousePosition.y, screenPoint.z);
        curPosition = Camera.main.ScreenToWorldPoint(curScreenPoint) + offset;
        if(freezeX) {   transform.localPosition = new Vector3(freezeOffset, curPosition.y, curPosition.z);   }

        if(freezeY) {   transform.localPosition = new Vector3(curPosition.x, freezeOffset, curPosition.z);   }
        
        if(freezeZ) {   transform.localPosition = new Vector3(curPosition.x, curPosition.y, freezeOffset);   }
    }
    void OnMouseUp() 
    {
        dragging = false;
    }
}
