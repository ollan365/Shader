using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class SetRadiusProperties : MonoBehaviour
{
    public Material radiusMat;
    public float radius = 1;
    public float radiusWidth = 1;
    public Color color = Color.black;

    private void Update()
    {
        radiusMat.SetVector("_Center", transform.position);
        radiusMat.SetFloat("_Radius", radius);
        radiusMat.SetFloat("_RadiusWidth", radiusWidth);
        radiusMat.SetColor("_RadiusColor", color);
    }
}
