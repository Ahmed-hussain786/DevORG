public class Flower {
    
    Public Static integer Wilt(integer numberOfPetals){
        if(numberOfPetals>=1){
            numberOfPetals--;
        }
        System.debug(numberofPetals);
        return numberofPetals;
    }
    
    Public static void grow(Integer height,Integer maxHeight){
        height=height+2; 
        if(height>=maxHeight){   
            Pollinate();
        } 
    }
    
    Public Static Void Pollinate(){
        System.debug('Pollinating...');
    }
    
}