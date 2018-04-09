println("Newtons Method to find Square root of a Number using successive approximations!")
                                                  //> Newtons Method to find Square root of a Number using successive approximations!
                                           
// taking the absolute of the input
def abs(x: Double) = if(x < 0) -x else x        //> abs: (x: Double)Double
  
// defining the operations recursively
def sqrt_iter(guess: Double, x: Double): Double = if (isGoodEnough(guess, x)) guess else sqrt_iter(improve_guess(guess, x), x)		//> sqrt_iter: (guess: Double, x: Double)Double
  
  // Checking if the approximation is good enough
  def isGoodEnough(guess: Double, x: Double) = abs(guess * guess - x) < 0.0001           //> isGoodEnough: (guess: Double, x: Double)Boolean
  
  // Improving the guess
  def improve_guess(guess: Double, x: Double) = (guess + x / guess ) / 2                  //> improve_guess: (guess: Double, x: Double)Double

	// finally calling all functions!
  def sqrt(x: Double) = sqrt_iter(1.0, x)         //> sqrt: (x: Double)Double
  
  sqrt(2)                                         //> res0: Double = 1.4142156862745097