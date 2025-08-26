public class POW {
    public double myPow(double x, int n) {
        if (n == 0) return 1;        
        if (n == Integer.MIN_VALUE) {
            x = x * x;
            n = n / 2;
        }        
        long N = Math.abs((long) n);
        double result = 1.0;        
        while (N > 0) {
            if (N % 2 == 1) {
                result *= x;
            }
            x *= x;
            N /= 2;
        }        
        return n < 0 ? 1 / result : result;
    }
}