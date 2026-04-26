package cpsc326;

import java.util.List;

class OurPLFunction implements OurPLCallable{
    private final Stmt.Function declaration;

    OurPLFunction(Stmt.Function declaration) {
        this.declaration = declaration;
    }

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
