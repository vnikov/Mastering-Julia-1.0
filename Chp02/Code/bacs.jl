using Unicode
function bacs()
  bulls = cows = turns = 0
  a = Any[]
  while length(unique(a)) < 4 
    push!(a,rand('0':'9'))
    end
  my_guess = unique(a)
  print("\nBULLS and COWS\n===============")
  prompt = "\nEnter four distinct digits or <return> to quit"
  println(prompt)
  while (bulls != 4)
    print("Guess> "); 
    s = chomp(readline())
    if (length(s) == 0)
      print("My guess was "); [print(my_guess[i]) for i=1:4]
      return
    end
    guess = collect(s)
    if !(length(unique(guess)) == length(guess) == 4 && all(Unicode.isdigit,guess))
      println(prompt)
      continue
    end
    bulls = sum(map(==, guess, my_guess))
    cows = length(intersect(guess,my_guess)) - bulls
    println("$bulls bulls and $cows cows!")
    turns += 1
  end
  println("\nYou guessed my number in $turns turns.")
end


BULLS and COWS
===============
Enter four distinct digits or <return> to quit
Guess> 1234
0 bulls and 1 cows!
Guess> 5678
0 bulls and 1 cows!
Guess> 1590
2 bulls and 0 cows!
Guess> 2690
2 bulls and 0 cows!
Guess> 3790
2 bulls and 0 cows!
Guess> 4890
2 bulls and 2 cows!
Guess> 8490
4 bulls and 0 cows!

You guessed my number in 7 turns.
