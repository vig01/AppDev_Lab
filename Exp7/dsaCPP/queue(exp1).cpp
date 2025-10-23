#include <iostream>
using namespace std;
const int SIZE = 50;
class queue
{
private:
    int arr[SIZE];
    int front, rear;

public:
    queue();
    void insert(int x);
    int remove();
    void display();
};
queue::queue()
{
    front = -1;
    rear = -1;
}
void queue::insert(int x)
{
    if (rear == SIZE - 1)
    {
        cout << "Queue is full\n";
        return;
    }
    if (front == -1)
    {
        front = 0;
    }
    rear++;
    arr[rear] = x;
    cout << "Inserted: " << x << "\n";
}
int queue::remove()
{
    if (front == -1 || front > rear)
    {
        cout << "Queue is empty\n";
        return -1;
    }
    int data = arr[front];
    front++;
    if (front > rear)
    {
        front = rear = -1;
    }
    cout << "Removed " << data;
    return data;
}
void queue::display()
{
    if (front == -1 || front > rear)
    {
        cout << "Queue is empty\n";
        return;
    }
    else
    {
        cout << "Queue elements from front to rear: ";
        for (int i = front; i <= rear; i++)
        {
            cout << arr[i] << " ";
        }
        cout << "\n";
    }
}
int main()
{
    queue q;
    int element, choice;
    while (true)
    {
        cout << "\nInsert-1\nRemove-2\nDisplay-3\nExit-4\n";
        cout << "Enter your choice: ";
        cin >> choice;

        switch (choice)
        {
        case 1:
            cout << "Enter element to insert: ";
            cin >> element;
            q.insert(element);
            break;
        case 2:
            element = q.remove();
            break;
        case 3:
            q.display();
            break;
        case 4:
            return 0;
        default:
            cout << "Invalid choice\n";
        }
    }
    return 0;
}
