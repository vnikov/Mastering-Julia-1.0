#include <stdio.h>
#include <math.h>
#include <stdlib.h>

double c_pi(long n, int iseed) {
    long k = 0L;
    srand(iseed);
    for (long i = 0L; i < n; i++) {
        float x = ((float) rand())/((float) RAND_MAX);
        float y = ((float) rand())/((float) RAND_MAX);
        if ((x*x + y*y) < 1.0) {
          k++;
        }
    }
    return 4.0*((double) k)/((double) n);
}

int main() {
  double mypi = c_pi(100000000L, 117);
  printf("My estimate of PI is %lf\n", mypi);
}

