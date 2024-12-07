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
        // ���� ���� �� ��Ȱ��ȭ
        for(int i = 0; i < maxBubbleCount; i++)
        {
            bubbleList.Add(Instantiate(bubblePrefab, transform));
            bubbleList[bubbleList.Count - 1].SetActive(false);
        }

        // ���� ���� �Ϸ� �� ���� �̵� ���� ����
        StartCoroutine(BubbleMoveLogic());
    }
    
    private IEnumerator BubbleMoveLogic()
    {
        while (true)
        {
            // ������ ���� �ε��� ã�� (��� ������ Ȱ��ȭ �Ǿ������� ���)
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

            // ������ ������ ��ġ�� ������� ����
            RandomBubble(bubbleList[newBubbleIndex]);

            // ������ �ϳ� ���� �� ������ �ð��� ���� �Ŀ� �ٽ� ���� ����
            yield return new WaitForSeconds(Random.Range(3, 10));
        }
    }

    private void RandomBubble(GameObject bubble)
    {
        // ������ ��ǥ�� ������ ũ��� ������ ����� Ȱ��ȭ
        bubble.transform.localPosition = new Vector3(-6.5f, Random.Range(0, 4), 0);

        float randomScale = Random.Range(1f, 2.5f);
        bubble.transform.localScale = new Vector3(randomScale, randomScale, randomScale);
        
        bubble.SetActive(true);
    }
}
