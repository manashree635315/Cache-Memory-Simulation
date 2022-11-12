#include <vector>
#include <string>
#include <fstream>
#include <bitset>
#include <iostream>
#include <time.h>
 
using namespace std;

int randomNumberGenerator0To255() {
	return (rand() % 256);
}

int randomNumberGenerator0To1() {
	return (rand() % 2);
}

string convertingTo8BitBinaryString(int x) {
	return bitset<8>(x).to_string();
}

string convertingTo1BitBinaryString(int x) {
	if (x == 0) {
		return "0"; //read
	}else {
		return "1"; //write
	}
}

int main() {
	srand(time(NULL));
	vector<string> encodedBinaryStrings;
	for (int i = 0; i < 200; i++) {
		string s = "";
		if (randomNumberGenerator0To1() == 0) {
			s += convertingTo1BitBinaryString(0);
			s += convertingTo8BitBinaryString(randomNumberGenerator0To255());
			s += convertingTo8BitBinaryString(0);
		}else {
			s += convertingTo1BitBinaryString(1);
			s += convertingTo8BitBinaryString(randomNumberGenerator0To255());
			s += convertingTo8BitBinaryString(randomNumberGenerator0To255());	
		}
		encodedBinaryStrings.push_back(s);
	}
	// fstream fopen;
	// fopen.open("200EncodedQueries.txt", ios::out | ios::in);
	ofstream fopen("200EncodedQueries.txt");
	for (int i = 0; i < encodedBinaryStrings.size(); i++) {
		fopen << encodedBinaryStrings[i] << endl;
		//cout << encodedBinaryStrings[i] << endl;
	}
	fopen.close();
	return 0;
}