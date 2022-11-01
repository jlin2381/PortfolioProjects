/*	This program asks a panel of (7) judges for (1) degree of difficulty score and each of their scores. The best and worst scores are
    removed from the list. The remaining are summed and multiplied by the difficulty and .6 to return a total score.
*/

#include <iostream>
using namespace std;
const int MAX_NUMBER_SCORES = 7;
void fillArray(int a[], int size, int &numberUsed);
void sort(int a[], int numberUsed);
void swapValues(int& v1, int& v2);
int indexOfSmallest(const int a[], int startIndex, int numberUsed);
double difficulty = 0;
double overall = 0;
int main()
{
	cout << "Enter degree of difficulty:\n";
	cin >> difficulty;

	int score[MAX_NUMBER_SCORES],numberUsed;
	cout << "Enter scores" << endl;
	fillArray(score, MAX_NUMBER_SCORES, numberUsed);
	sort(score, numberUsed);
	
	double total = 0;
	for (int index = 1; index < numberUsed - 1; index++)

		total = (total + score[index]);

	

	overall = (difficulty * total * .6);
	cout << overall << endl;
	system("Pause");
		return 0;
}
void fillArray(int a[], int size, int& numberUsed)
{
	cout << "Enter up to " << size << " nonnegative whole numbers.\n"
		 << "Mark the end of the list with a negative number.\n";
	int next, index = 0;
	cin >> next;
	while ((next >= 0) && (index < size))
	{
		a[index] = next;
		index++;
		cin >> next;
	}
	numberUsed = index;	
}
void sort(int a[], int numberUsed)
{
	int indexOfNextSmallest;
	for (int index = 0; index < numberUsed - 1; index++)
	{//Place the correct value in a[index]:
		indexOfNextSmallest =
			indexOfSmallest(a, index, numberUsed);
		swapValues(a[index], a[indexOfNextSmallest]);
		//a[0] <= a[1] <=...<= a[index] are the smallest of the original array
		//elements. The rest of the elements are in the remaining positions.
	}
}
void swapValues(int& v1, int& v2)
{
	int temp;
	temp = v1;
	v1 = v2;
	v2 = temp;
}
int indexOfSmallest(const int a[], int startIndex, int numberUsed)
{
	int min = a[startIndex],
		indexOfMin = startIndex;
	for(int index = startIndex + 1; index < numberUsed; index++)
		if (a[index] < min)
		{
			min = a[index];
			indexOfMin = index;
			//min is the smallest of a[startIndex] through a[index]
		}
	return indexOfMin;
}
