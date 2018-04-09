object Factorial {
  println("Factorial of a Number in a tail recursive manner!")
                                                  //> Factorial of a Number in a tail recursive manner!
  
  
  // normal method
  def factorial(n: Int): Int = if (n == 0) 1 else n * factorial(n - 1)
                                                  //> factorial: (n: Int)Int
  
  factorial(5)                                    //> res0: Int = 120
  
  // tail recursive version
  def factorial_tail_recursive(n: Int): Int = {
  	def loop(acc: Int, n: Int): Int =
  		if(n==0) acc
  		else loop(acc*n, n-1)
  		loop(1, n)
   
 }                                                //> factorial_tail_recursive: (n: Int)Int
 factorial_tail_recursive(5)                      //> res1: Int = 120
}