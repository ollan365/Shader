using System.Collections;
using UnityEngine;

public class BubbleMovement : MonoBehaviour
{
    [Range(0.01f, 10f)] [SerializeField] private float burstTime;
    [SerializeField] private bool wantToMove = true;
    private float speed;
    private Coroutine movementCoroutine;

    private void OnEnable()
    {
        if(wantToMove) movementCoroutine = StartCoroutine(Move());
    }
    private void OnDisable()
    {
        if(movementCoroutine != null) StopCoroutine(movementCoroutine);
    }

    private IEnumerator Move()
    {
        speed = Random.Range(0, 3) + 0.5f;

        while (true)
        {
            Vector3 startPosition = transform.position;
            float time = Time.time;

            // ������ �߰��� �̵�
            float offsetX = Mathf.PerlinNoise(time, 0);
            float offsetY = Mathf.PerlinNoise(0, time) * 0.3f; // ���� ������ ���ϰ�

            // �ε巯�� ���Ʒ� �̵�
            float verticalMotion = Mathf.Sin(time) * 0.1f;

            // ���ο� ��ġ ���
            Vector3 newPosition = startPosition + new Vector3(
                offsetX,
                verticalMotion + offsetY,
                0
            );

            transform.position = Vector3.Lerp(transform.position, newPosition, speed * Time.deltaTime);

            if (transform.localPosition.x >= 7 || transform.localPosition.y >= 7) gameObject.SetActive(false);

            yield return new WaitForFixedUpdate();
        }
    }

    private void OnMouseDown()
    {
        Vector3 mouseScreenPosition = Input.mousePosition;

        Ray ray = Camera.main.ScreenPointToRay(mouseScreenPosition);
        if (Physics.Raycast(ray, out RaycastHit hit))
        {
            Vector3 worldPosition = hit.point;
            gameObject.GetComponent<Renderer>().material.SetVector("_ClickPosition", new Vector4(worldPosition.x, worldPosition.y, worldPosition.z, 1));
        }

        // �񴰹���� �Ͷ߸�
        StartCoroutine(DelaySetActiveFalse());
    }

    private IEnumerator DelaySetActiveFalse()
    {
        float currentTime = 0, maxDistance = gameObject.transform.localScale.x * (2 + speed * burstTime);
        while(currentTime < burstTime)
        {
            currentTime += Time.deltaTime;
            float currentRadius = Mathf.Lerp(0, maxDistance, currentTime / burstTime);
            gameObject.GetComponent<Renderer>().material.SetFloat("_BurstRadius", currentRadius);
            yield return null;
        }
        gameObject.GetComponent<Renderer>().material.SetFloat("_BurstRadius", 0);
        gameObject.SetActive(false);
    }
}
