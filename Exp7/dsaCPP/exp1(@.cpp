#include <iostream>
#include <string.h>
using namespace std;

class stack {
private:
    int top;
    static const int max = 1000;
    char arr[max];

public:
    stack() { top = -1; }

    void push(int x) {
        if (top >= (max - 1)) {
            cout << "stack is full\n";
        } else {
            ++top;
            arr[top] = x;
            cout << "pushed to stack\n";
        }
    }

    int pop() {
        if (top < 0) {
            cout << "stack is empty\n";
            return -1;
        } else {
            return arr[top--];
        }
    }

    int stacktop() {
        if (top < 0) {
            cout << "Stack is Empty\n";
            return -1;
        }
        return arr[top];
    }

    bool empty() {
        if (top < 0) {
            return true;
        } else {
            return false;
        }
    }
};

int main() {
    stack stack;
    int valid=1;
    string exp;
    cout<<"enter expression";
    cin>>exp;

    int a=exp.length();
     char symb;
    for (int i=0;i<a;i++){
        symb=exp[i];
        if(symb=='('||symb=='{'||symb=='['){
            stack.push(symb);
        }

        if(symb==')'|| symb=='}'||symb==']'){
            if(stack.empty()){
                valid=0;
            }
            else{
                int a=stack.pop();
                 if ((symb == ')' && a != '(') ||(symb == '}' && a != '{') ||(symb == ']' && a!= '[')){
                    valid=0;
                }


            }

        }

    }

    if(!stack.empty()){
        valid=0;
    }

    if (valid)
    {
        cout<<"expression is valid";
    }
    else{
        cout<<"string is not valid";
    }

}
