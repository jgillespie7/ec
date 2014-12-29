#include <stdio.h>

int main(){
double dt = 0.01;
double t = 0;
double v = 0;
double x = 1;
while (t < 6.28){
t += dt;
x += (v)*dt;
v += (-x)*dt;
printf("%f %f %f\n", t, x, v);
}
}
