#include <iostream>
using namespace std;

int L, R, K;
string respon;

int main(){
  cin >> L >> R >> K;
  while(L<=R){
    cout << 0 << " " << L << "\n";
    fflush(stdout);
    
    cin >> respon;
    if(respon == "YA"){
      cout << 1 << " " << L << "\n";
      fflush(stdout);
    }else L++;
  }
  
  return 0;
}
