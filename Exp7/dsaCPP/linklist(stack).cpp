#include <iostream>

using namespace std;

class Node {
public:
    int data;
    Node* next;
    Node(int val) {
        data = val;
        next = nullptr;
    }
};

class Stack {
private:
    Node* top;
public:
    Stack() {
        top = nullptr;
    }
    void push(int val) {
        Node* newNode = new Node(val);
        newNode->next = top;
        top = newNode;
        cout << val << " pushed." << endl;
    }
    void pop() {
        if (top == nullptr) {
            cout << "Stack Underflow! Nothing to pop." << endl;
            return;
        }
        Node* temp = top;
        cout << temp->data << " popped." << endl;
        top = top->next;
        delete temp;
    }
    void peek() {
        if (top == nullptr) {
            cout << "Stack is empty! Nothing to peek." << endl;
        } else {
            cout << "Top element: " << top->data << endl;
        }
    }
    void display() {
        if (top == nullptr) {
            cout << "Stack is empty!" << endl;
            return;
        }
        cout << "Stack elements: ";
        Node* temp = top;
        while (temp != nullptr) {
            cout << temp->data << " ";
            temp = temp->next;
        }
        cout << endl;
    }
};

int main() {
    Stack s;
    int choice;
    int val;
    cout << "Stack using Linked List" << endl;
    cout << "1. Push 2. Pop 3. Display 4. Peek 5. Exit" << endl;
    while (true) {
        cout << "Enter choice: ";
        cin >> choice;
        switch (choice) {
            case 1:
                cout << "Enter value to push: ";
                cin >> val;
                s.push(val);
                break;
            case 2:
                s.pop();
                break;
            case 3:
                s.display();
                break;
            case 4:
                s.peek();
                break;
            case 5:
                cout << "Exiting program" << endl;
                return 0;
            default:
                cout << "Invalid choice! Try again." << endl;
        }
    }
    return 0;
}
