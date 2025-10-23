#include <iostream>
#define MAX 100
using namespace std;

class stack {
private:
    int arr[MAX];
    int top;

public:
    stack() {
        top = -1;
    }

    void push() {
        if (top == MAX - 1) {
            cout << "Stack Overflow! Cannot push more elements!\n";
            return;
        }

        int n;
        cout << "Enter element to push: ";
        cin >> n;

        top++;
        arr[top] = n;
        display();
    }

    void pop() {
        if (top == -1) {
            cout << "Stack Underflow! empty stack!\n";
            return;
        }
        cout << "Element popped: " << arr[top] << endl;
        top--;
        display();
    }

    void display() {
        if (top == -1) {
            cout << "Stack is empty.\n";
            return;
        }
        cout << "Stack: ";
        for (int i = 0; i <= top; i++) {
            cout << arr[i] << " ";
        }
        cout << endl;
    }
};

int main() {
    stack s;
    int choice;
    while (true) {
        cout << "\nStack Menu\n";
        cout << "1) Push\n2) Pop\n3) Display\n4) Exit\n";
        cout << "Enter your choice: ";
        cin >> choice;

        switch (choice) {
            case 1:
                s.push();
                break;
            case 2:
                s.pop();
                break;
            case 3:
                s.display();
                break;
            case 4:
                cout << "Exiting program\n";
                return 0;
            default:
                cout << "Invalid Choice\n";
        }
    }
    return 0;
}
