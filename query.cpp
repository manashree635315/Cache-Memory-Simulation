#include<bits/stdc++.h>
#include <fstream>
using namespace std;



string HexToBinary(string s){

    string return_string = "";

    int i = 0;

    while(i<7)
    {
        if(s[i]=='0')
        return_string = return_string + "0000";

        else if(s[i]=='1')
        return_string = return_string + "0001";

        else if(s[i]=='2')
        return_string = return_string + "0010";

        else if(s[i]=='3')
        return_string = return_string + "0011";

        else if(s[i]=='4')
        return_string = return_string + "0100";

        else if(s[i]=='5')
        return_string = return_string + "0101";

        else if(s[i]=='6')
        return_string = return_string + "0110";

        else if(s[i]=='7')
        return_string = return_string + "0111";

        else if(s[i]=='8')
        return_string = return_string + "1000";

        else if(s[i]=='9')
        return_string = return_string + "1001";

        else if(s[i]=='A')
        return_string = return_string + "1010";

        else if(s[i]=='B')
        return_string = return_string + "1011";

        else if(s[i]=='C')
        return_string = return_string + "1100";

        else if(s[i]=='D')
        return_string = return_string + "1101";

        else if(s[i]=='E')
        return_string = return_string + "1110";

        else if(s[i]=='F')
        return_string = return_string + "1111";

        else if(s[i]=='a')
        return_string = return_string + "1010";

        else if(s[i]=='b')
        return_string = return_string + "1011";

        else if(s[i]=='c')
        return_string = return_string + "1100";

        else if(s[i]=='d')
        return_string = return_string + "1101";

        else if(s[i]=='e')
        return_string = return_string + "1110";

        else if(s[i]=='f')
        return_string = return_string + "1111";

        i++;
    }

    return return_string;

}



string ConvertString(string line){
 
    if(line.length() == 6)
    {
        string substring = line.substr(1, 5);
        
        if(line.at(0) == '1')
        line = "00";

        else line = "10";
        line = line + substring;
    }

    else
    {
        string substring = line.substr(1, 6);
        if(line.at(0) == '1')
        line = "0";

        else line = "1";
        line = line + substring;
    }
    return HexToBinary(line).substr(3, 27);



}

string removeSpaces(string str)
{
    str.erase(remove(str.begin(), str.end(), ' '), str.end());
    return str;
}

int main(){
    ifstream file;
    file.open("instruction.txt");

    ofstream output_file("binary_instruction.txt");

    if(file.is_open())
    {
        
    string line;

    while(getline(file, line))
    {
        string s = line;

        s = removeSpaces(s);


        if (output_file.is_open())
        {
            string p = ConvertString(s);
            output_file<<p<<endl;
            // output_file<<s<<endl;
        }

    }
    }

    output_file.close();





}