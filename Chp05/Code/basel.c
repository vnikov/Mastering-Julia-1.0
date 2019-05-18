/*
cc -c basel.c
libtool -dynamic basel.o -o libmyfuns.dylib -framework CoreFoundation -lSystem -macosx_version_min 10.12
sudo cp libmyfuns.dylib /usr/local/lib
*/

#include<stdio.h>
#include<stdlib.h>

double basel(int N) {

  double s = 0.0L;
  int i;
  double x;

  if (N < 1) return s;
  for (i = 1; i <= N; i++) {
    x = 1.0L/((double) i);
    s += x*x;
  }
  return s;
}

// int main() {
//    int K = 10000000;
//    printf("Estimate is %.10g\n", basel(K));
//    printf("Number of terms in series was %d\n", K);
//    exit(0);
// }
