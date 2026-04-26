package cpsc326;

import java.util.List;

class OurPLFunction implements OurPLCallable{
    private final Stmt.Function declaration;

    OurPLFunction(Stmt.Function declaration) {
        this.declaration = declaration;
    }


//makes a new env with interpreter passed in when calling function. 
//we are going through each of the arguments and defining them in the scope to actual variables
//so we can use them in the function environment
//then we execute the block of the function, and call return.
    @Override
    public Object call(Interpreter interpreter, List<Object> arguments) {  
        Environment environment = new Environment(interpreter.environment);
        
        for (int i = 0; i < declaration.params.size(); i++) {
            environment.define(declaration.params.get(i).lexeme, arguments.get(i));
        }

        try {
            interpreter.executeBlock(declaration.body, environment);
        }
        catch(Return returnValue){
            return returnValue.value;
        }

        return null;

    }

    @Override
    public int arity() {
        return declaration.params.size();
        
    }

    @Override
    public String toString() {
        return "< fn " + declaration.name.lexeme + ">";
    }
}
