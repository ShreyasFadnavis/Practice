object Higher_Order_Functions {
  println("Higher Order Functions")               //> Higher Order Functions
  
  //take the sum of all the numbers between two numbers
  def sum_between(a: Int, b: Int): Int =
  	if (a>b) 0 else a + sum_between(a + 1, b) //> sum_between: (a: Int, b: Int)Int
 
	sum_between(5, 10)                        //> res0: Int = 45
	
	//take the sum of all cubes of numbers between two numbers
	def cube(x: Int): Int = x * x * x         //> cube: (x: Int)Int
	
	def sum_of_cubes(a:Int, b: Int): Int =
		if (a>b) 0 else cube(a) + sum_between(cube(a+1), cube(b))
                                                  //> sum_of_cubes: (a: Int, b: Int)Int
	
	sum_of_cubes(5, 10)                       //> res1: Int = 477405
}


	