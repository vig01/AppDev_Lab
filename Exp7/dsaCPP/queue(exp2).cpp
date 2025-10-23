#include <iostream>
using namespace std;
const int SIZE = 50;
class Deque
{
private:
    int arr[SIZE];
    int front, rear;
public:
    Deque();
    void insertFront(int x);
    void insertRear(int x);
    int deleteFront();
    int deleteRear();
    void display();
};
Deque::Deque()
{
    front = -1;
    rear = -1;
}
void Deque::insertFront(int x)
{
    if ((front == 0 && rear == SIZE - 1) || (front == rear + 1))
    {
        cout << "Deque is full\n";
        return;
    }
    if (front == -1)
    {
        front = rear = 0;
    }
    else if (front == 0)
    {
        front = SIZE - 1;
    }
    else
    {
        front--;
    }
    arr[front] = x;
    cout << "Inserted at front: " << x << endl;
}
void Deque::insertRear(int x)
{
    if ((front == 0 && rear == SIZE - 1) || (front == rear + 1))
    {
        cout << "Deque is full\n";
        return;
    }
    if (front == -1)
    {
        front = rear = 0;
    }
    else if (rear == SIZE - 1)
    {
        rear = 0;
    }
    else
    {
        rear++;
    }
    arr[rear] = x;
    cout << "Inserted at rear: " << x << endl;
}
int Deque::deleteFront()
{
    if (front == -1)
    {
        cout << "Deque is empty\n";
        return -1;
    }
    int data = arr[front];
    if (front == rear)
    {
        front = rear = -1;
    }
    else if (front == SIZE - 1)
    {
        front = 0;
    }
    else
    {
        front++;
    }
    return data;
}
int Deque::deleteRear()
{
    if (front == -1)
    {
        cout << "Deque is empty\n";
        return -1;
    }
    int data = arr[rear];
    if (front == rear)
    {
        front = rear = -1;
    }
    else if (rear == 0)
    {
        rear = SIZE - 1;
    }
    else
    {
        rear--;
    }
    return data;
}
void Deque::display()
{
    if (front == -1)
    {
        cout << "Deque is empty\n";
        return;
    }
    cout << "Deque elements: ";
    int i = front;
    while (true)
    {
        cout << arr[i] << " ";
        if (i == rear)
        {
            break;
        }
        i = (i + 1) % SIZE;
    }
    cout << endl;
}
int main()
{
    Deque dq;
    int choice, subChoice, element;
    while (true)
    {
        cout << "\n1.Insert\n2.Remove\n3.Display\n4.Exit\n";
        cout << "Enter your choice: ";
        cin >> choice;

        switch (choice)
        {
        case 1:
            cout << "Insert at:\n1.Front\n2.Rear\nEnter your sub-choice: ";
            cin >> subChoice;
            cout << "Enter element to insert: ";
            cin >> element;
            if (subChoice == 1)
            {
                dq.insertFront(element);
            }
            else if (subChoice == 2)
            {
                dq.insertRear(element);
            }
            else
            {
                cout << "Invalid sub-choice\n";
            }
            break;
        case 2:
            cout << "Remove from:\n1.Front\n2.Rear\nEnter your sub-choice: ";
            cin >> subChoice;
            if (subChoice == 1)
            {
                element = dq.deleteFront();
                if (element != -1)
                {
                    cout << "Removed from front: " << element << endl;
                }
            }
            else if (subChoice == 2)
            {
                element = dq.deleteRear();
                if (element != -1)
                {
                    cout << "Removed from rear: " << element << endl;
                }
            }
            else
            {
                cout << "Invalid sub-choice\n";
            }
            break;
        case 3:
            dq.display();
            break;
        case 4:
            return 0;
        default:
            cout << "Invalid choice\n";
        }
    }
    return 0;
}
