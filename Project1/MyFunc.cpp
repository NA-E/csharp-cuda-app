#define MyFunc _declspec(dllexport)

extern "C" {
	MyFunc int addNums(int a, int b) {

		
		return a + b;
	}
}