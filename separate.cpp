#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int main() {

	ifstream infile("githubJsonOneLine.txt");
	string myLine;
	int count = 0;

	while (getline(infile, myLine)) {
		ofstream outfile;
		outfile.open(to_string(count).c_str());
		count++;
		outfile << myLine << endl;
		outfile.close();
	}

	infile.close();

	return 0;
}