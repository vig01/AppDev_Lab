#include <iostream>
using namespace std;
int main(){
    int marks;
    cout<<"enter the marks:";
    cin>>marks;
    if(marks>=75){
        cout<<"A grade\n";
    }else if(marks>=40){
        cout<<"pass\n";
    }else{
        cout<<"fail\n";
    }
    return 0;
}

