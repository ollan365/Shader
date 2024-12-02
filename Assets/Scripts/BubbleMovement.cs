using System.Collections;
using UnityEngine;

public class BubbleMovement : MonoBehaviour
{
    private Coroutine movementCoroutine;

    private void OnEnable()
    {
        movementCoroutine = StartCoroutine(Move());
    }
    private void OnDisable()
    {
        StopCoroutine(movementCoroutine);
    }

    private IEnumerator Move()
    {
        float speed = Random.Range(0, 3) + 0.5f;

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
        // ���콺 ��ġ�� ��ũ�� ��ǥ�� ������
        Vector3 mouseScreenPosition = Input.mousePosition;

        // ��ũ�� ��ǥ�� ���� ��ǥ�� ��ȯ
        Vector3 mouseWorldPosition = Camera.main.ScreenToWorldPoint(new Vector3(
            mouseScreenPosition.x,
            mouseScreenPosition.y,
            Camera.main.WorldToScreenPoint(transform.position).z // ������Ʈ�� ī�޶� �� �Ÿ�
        ));

        // ���� ��ǥ�� ���� ��ǥ�� ��ȯ
        Vector3 localPosition = transform.InverseTransformPoint(mouseWorldPosition);
        Vector4 clickPosition = new Vector4(localPosition.x, localPosition.y, localPosition.z, 1);
        gameObject.GetComponent<Renderer>().material.SetVector("_ClickPosition", clickPosition);
    }
}
