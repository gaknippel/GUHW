package cpsc326;
import java.util.HashMap;
import java.util.Map;

public class Environment {

    Environment enclosing;

    Map<String, Object> values = new HashMap<>(); //our hash map to store our statements in
    

    Environment(){ //constructor 1

    }

    Environment(Environment enclosing){ //constructor 2
        this.enclosing = enclosing;
    }


    void define(String name, Object value){ //defines vars
        values.put(name,value);
    }

    Object get(Token name){ //fetches vars
        if(values.containsKey(name.lexeme)){
            return values.get(name.lexeme);
        }

        if (enclosing != null){
            return enclosing.get(name);
        }

        throw new RuntimeError(name, "Undefined variable '" + name.lexeme + "'.");

    }

    void assign(Token name, Object value) //assigning vars
    {
        if(values.containsKey(name.lexeme)){
            values.put(name.lexeme, value);
            return;
        }
        if(enclosing != null){
            enclosing.assign(name, value);
            return;
        }

        throw new RuntimeError(name, "Undefined variable '" + name.lexeme + "'.");

    }
}
