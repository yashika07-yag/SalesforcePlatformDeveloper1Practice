public class CountVowelConsonant{

    public static void countwords(String str){

        if(String.isBlank(str)){
            System.debug('Enter a valid string.');
            return;
        }
        integer vowels = 0 , consonants =0;
        str = str.tolowercase();
         for(integer i = 0;i<str.length();i++){

            string ch = str.substring(i,i+1);
            if(ch>= 'a' && ch<='z'){
                if('aeiou'.contains(ch)){
                    vowels++;
                }
                else{
                    consonants++;
                }
            }
            
         }
         System.debug('Vowels Count: ' + vowels + 'Consonants Count: ' + consonants);
    }
}