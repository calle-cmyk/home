public class Zahlenfilter2 {

    public static void main(String[] args) {


        for(int i = 1; i<200; i++){

            if (i%5==0){

                System.out.println(i + " ist durch 5 teilbar");

            }

            if (i % 10 ==9){

                System.out.println(i + " endet auf 9");

            }

            int a = (i-1);
            int c = (i+a);
            if ((i + a) %3 ==0 ) {

                System.out.println(i + " und " + a + " addiert ergeben " +c+ " und " +c+ " ist durch 3 teilbar.");
            }

        }

        Visitenkarte vis = new Visitenkarte();
        vis.toString();
        System.out.println(vis);




    }
}
