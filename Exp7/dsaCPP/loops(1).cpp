#include <iostream>
using namespace std;

int main() {
    int n;
    cout << "Enter a number: ";
    cin >> n;

    if (n >= 0) {
        cout << "number is positive" << endl;
    } else {
        cout << "number is negative" << endl;
    }

    return 0;
}
