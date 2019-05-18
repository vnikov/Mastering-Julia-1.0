#include<stdio.h>
#include<math.h>

double horner(double x, double aa[], int n);

int main() {
  double a[5] = {1.0, 2.0, 3.0, 4.0, 5.0};
  int    n = sizeof(a)/sizeof(a[0]);
  double p = horner(2.1, a, n);
  printf("%g\n",p);
  return 0;
}

