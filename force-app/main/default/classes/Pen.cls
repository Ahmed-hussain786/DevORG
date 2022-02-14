public class Pen {
    string penColour;
    string penBrand;
    integer penPrice;
    static integer penCount=0;
    //first constractor without any values
    public pen(){
        penCount++;
    }
    //second constractor,that initiates the object's varibles
    public Pen(string pBrand,string pColour,integer pPrice){
        penBrand=pBrand;
        penColour=pColour;
        penPrice=pPrice;
        penCount++;
    }
    //static method to display the penCout ststic varible
    public static void penCountNumber(){
        system.debug(penCount);
    }
    //method to output the pen info
    public void penInfo(){
        system.debug('i am a '+penColour +' '+penBrand +'Pen,with price:'+penPrice);
    }
    public void Write1(){
        system.debug('this is method 1');
        
    }
    public static void Write2(){
        system.debug('this is the method 2');
    }
}