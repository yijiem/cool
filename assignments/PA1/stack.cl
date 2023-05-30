(*
 *  CS164 Fall 94
 *
 *  Programming Assignment 1
 *    Implementation of a simple stack machine.
 *
 *  Skeleton file
 *)

class Stack {
   -- Define operations on empty Stack.

   isNil() : Bool { true };

   display() : Object { self };

   top() : StackCommand { { abort(); new StackCommand; } };

   pop() : Stack { { abort(); self; } };

   push(command : StackCommand) : Stack {
      (new Cons).init(command, self)
   };
};

class Cons inherits Stack {

   command : StackCommand;  -- The command in this stack cell

   prev : Stack;  -- The rest of the stack

   isNil() : Bool { false };

   display() : Object {
      {
         command.print();
         prev.display();
      }
   };

   top() : StackCommand { command };

   pop() : Stack { prev };

   init(c : StackCommand, p : Stack) : Stack {
      {
         command <- c;
         prev <- p;
         self;
      }
   };
};

class StackCommand inherits IO {

   print() : Object { { abort(); self; } };

};

class PlusCommand inherits StackCommand {

   print() : Object { out_string("+\n") };

};

class SwapCommand inherits StackCommand {

   print() : Object { out_string("s\n") };

};

class IntCommand inherits StackCommand {

   val : Int;

   print() : Object { { out_int(val); out_string("\n"); } };

   value() : Int { val };

   init(i : Int) : IntCommand {
      {
         val <- i;
         self;
      }
   };

};

class Main inherits IO {

   stack : Stack;

   main() : Object {
      {
         stack <- new Stack;
         out_string(">");
         (let s : String <- in_string() in
            while (not s = "x") loop
               {
                  if s = "+" then stack <- stack.push(new PlusCommand) else
                  if s = "s" then stack <- stack.push(new SwapCommand) else
                  if s = "d" then stack.display() else
                  if s = "e" then {
		     if not stack.isNil() then {
                        (let command : StackCommand <- stack.top() in
		           {
		              stack <- stack.pop();
           	              case command of
           	                 p : PlusCommand => {
           	                    (let e1 : StackCommand <- stack.top() in
		           	       {
           	                          stack <- stack.pop();
					  if not stack.isNil() then {
           	                             (let e2 : StackCommand <- stack.top() in
		           	                {
           	                                   stack <- stack.pop();
		           		           -- This sucks...
		           		           case e1 of
		           		              i1 : IntCommand => {
		           		                 case e2 of
		           		                    i2 : IntCommand => {
           	                                                  stack <- stack.push(new IntCommand.init(i1.value() + i2.value()));
		           		                    };
		           		                    x : Object => { abort(); };
		           		                 esac;
		           		              };
		           		              x : Object => { abort(); };
		           		           esac;
		           		        }
		           	             );
				          }
					  else 0
					  fi;
		           	       }
		          	    );
           	                 };
           	                 s : SwapCommand => {
           	                    (let e1 : StackCommand <- stack.top() in
		           	       {
           	                          stack <- stack.pop();
					  if not stack.isNil() then {
           	                             (let e2 : StackCommand <- stack.top() in
		           	                {
           	                                   stack <- stack.pop();
           	                                   stack <- stack.push(e1);
           	                                   stack <- stack.push(e2);
		           		        }
		           	             );
				          }
					  else 0
					  fi;
		           	       }
		           	    );
           	                 };
           	                 x : Object => 0;
           	              esac;
			   }
		        );
		     }
		     else 0
		     fi;
                  }
		  else
		     stack <- stack.push(new IntCommand.init(new A2I.a2i(s)))
                  fi fi fi fi;
                  out_string(">");
                  s <- in_string();
               }
            pool
         );
      }
   };

};
