#include <iostream>
#include <fstream>
using namespace std;

ofstream vd("verdict");

int WA(){
	vd << "Verdict: Wrong Answer\n";
	return 0;
}

int AC(){
	vd << "Verdict: Accepted\n";
	return 0;
}

int TLE(){
	vd << "Verdict: Time Limit Excedeed\n";
	return 0;
}

int main(){
  int L, R, K, ans;
  cin >> ans >> L >> R >> K; //get input file
  
  cout << L << " " << R << " " << K << endl;
  fflush(stdout);
  
  for(int i=1;i<=K;i++){
    int id, angka;
    
    cin >> id >> angka;
    if(id == 0){
      if(angka == ans) cout << "YA\n";
      else cout << "TIDAK\n";
      
      fflush(stdout);
      
    }else{
      if(angka == ans) return AC();
      else return WA();
    }
  }
  
  return TLE();
}
