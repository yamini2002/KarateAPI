package helpers;

import com.github.javafaker.Faker;
import com.linecorp.armeria.internal.shaded.bouncycastle.jcajce.provider.asymmetric.ec.GMSignatureSpi.sha256WithSM2;

public class DataGenerator {
    
    public static String getRandomNumber(){
        Faker faker = new Faker();
        String email = faker.name().firstName().toLowerCase() + faker.random().nextInt(0, 100) + "@test.com";
        return email;
    }

    public static String getRandomName(){
        Faker faker = new Faker();
        String username = faker.name().username();
        return username;
    }
}
