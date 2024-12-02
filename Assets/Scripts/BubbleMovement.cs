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

            // 난류를 추가한 이동
            float offsetX = Mathf.PerlinNoise(time, 0);
            float offsetY = Mathf.PerlinNoise(0, time) * 0.3f; // 세로 난류를 약하게

            // 부드러운 위아래 이동
            float verticalMotion = Mathf.Sin(time) * 0.1f;

            // 새로운 위치 계산
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
        // 마우스 위치를 스크린 좌표로 가져옴
        Vector3 mouseScreenPosition = Input.mousePosition;

        // 스크린 좌표를 월드 좌표로 변환
        Vector3 mouseWorldPosition = Camera.main.ScreenToWorldPoint(new Vector3(
            mouseScreenPosition.x,
            mouseScreenPosition.y,
            Camera.main.WorldToScreenPoint(transform.position).z // 오브젝트와 카메라 간 거리
        ));

        // 월드 좌표를 로컬 좌표로 변환
        Vector3 localPosition = transform.InverseTransformPoint(mouseWorldPosition);
        Vector4 clickPosition = new Vector4(localPosition.x, localPosition.y, localPosition.z, 1);
        gameObject.GetComponent<Renderer>().material.SetVector("_ClickPosition", clickPosition);
    }
}
