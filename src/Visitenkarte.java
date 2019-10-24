public class Visitenkarte {

    String name = "Rueckerl";
    String vorname = "Carl-Louis";
    String  beruf = "Student";
    int alter = 25;
    String adresse = "Spenglerstrasse";
    int nummer = 12345678;


    public String toString(){
        String s = name + ", " + vorname + "\n" + beruf + ", " + alter + "\n" + adresse + "\n" + nummer;
        return s;
    }

}
