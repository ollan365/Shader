using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BubbleManager : MonoBehaviour
{
    public static BubbleManager Instance { get; private set; }

    [SerializeField] private int maxBubbleCount;
    [SerializeField] private GameObject bubblePrefab;
    private List<GameObject> bubbleList;

    private void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
            bubbleList = new();
        }
        else Destroy(gameObject);
    }

    void Start()
    {
        // 버블 생성 후 비활성화
        for(int i = 0; i < maxBubbleCount; i++)
        {
            bubbleList.Add(Instantiate(bubblePrefab, transform));
            bubbleList[bubbleList.Count - 1].SetActive(false);
        }

        // 버블 생성 완료 후 버블 이동 로직 시작
        StartCoroutine(BubbleMoveLogic());
    }
    
    private IEnumerator BubbleMoveLogic()
    {
        while (true)
        {
            // 생성할 버블 인덱스 찾기 (모든 버블이 활성화 되어있으면 대기)
            int newBubbleIndex = -1;
            while(newBubbleIndex == -1)
            {
                for(int i = 0; i< bubbleList.Count; i++)
                {
                    if (!bubbleList[i].activeSelf)
                    {
                        newBubbleIndex = i;
                        break;
                    }
                }
                yield return new WaitForFixedUpdate();
            }

            // 버블을 랜덤한 위치와 모습으로 변경
            RandomBubble(bubbleList[newBubbleIndex]);

            // 버블을 하나 만든 후 랜덤한 시간이 지난 후에 다시 버블 생성
            yield return new WaitForSeconds(Random.Range(3, 10));
        }
    }

    private void RandomBubble(GameObject bubble)
    {
        // 랜덤한 좌표에 랜덤한 크기로 버블을 만들고 활성화
        bubble.transform.localPosition = new Vector3(-6.5f, Random.Range(0, 4), 0);

        float randomScale = Random.Range(1f, 2.5f);
        bubble.transform.localScale = new Vector3(randomScale, randomScale, randomScale);
        
        bubble.SetActive(true);
    }
}
