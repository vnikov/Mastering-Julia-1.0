#include<stdio.h>
#include<math.h>

double horner(double x, double aa[], long n) {
  long i;
  double s = aa[n-1];

  if (n > 1) { 
    for (i = n-2; i >= 0; i--) {
      s = s*x + aa[i];
    }
  }
  return s;
}
