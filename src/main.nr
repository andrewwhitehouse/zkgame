//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//       _  _  _  _  ___ __  _    ___       //
//~~~~~~| \| |/ \| || o \  \| |  | __|~~~~~~//
//------| \\ ( o ) ||   / o ) |_ | _|-------//
//~~~~~~|_|\_|\_/|_||_|\|__/|___||___|~~~~~~//
//          A little ZK Math Puzzle         //
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//       0 = 00     5 = 05     + = 10       //
//       1 = 01     6 = 06     - = 11       //
//       2 = 02     7 = 07     * = 12       //
//       3 = 03     8 = 08     / = 13       //
//       4 = 04     9 = 09     = = 14       //
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

use dep::std;

fn main(guess: [Field; 8], solution:[Field; 8], solution_hash: pub Field) {
    // Checks hash of the solution is unchanged
    let hash = std::hash::pedersen(solution)[0];
    assert(solution_hash == hash);

    // Checks if guess is valid
    assert(check_valid(guess));

    // Checks if math is correct
    assert(check_math(guess));

    // Returns result of players guess 
    // 0x00: Black  - not in solution
    // 0x01: Yellow - in solution
    // 0x02: Green  - correct guess
    let result: [Field; 8] = compare_guess(guess, solution);
    std::println(result);
}

// Checks guess and returns true is all constraints are met
fn check_valid(guess: [Field; 8]) -> bool {
    let mut equals = 0;

    for i in 0..8 {
        // Verify numbers in guess aren't larger than 14
        assert(guess[i] as u64 < 15);

        // Verify two operators aren't beside eachother
        if guess[i] as u64 > 9 {
            assert(guess[i + 1] as u64 < 10);
        }

        // If the symbol is the equals sign iterate equals, should be 1
        if guess[i] == 14 {
            equals += 1;
        }
    }

    // Verify theres a single equal sign (14)
    // Assertion for it being last operator is done in check_math()
    assert(equals == 1);

    // Verify 14 is not last character in sequence.
    assert(guess[7] != 14);

    // Verify first character isn't an operator (10, 11, 12, 13, 14)
    assert(guess[0] as u64 < 10);

    true
}

// Check if guess is mathematically valid
fn check_math(guess: [Field; 8]) -> bool {
    // Get list of operators
    let mut ops: [Field] = [0; 3];
    let mut j = 0;
    let mut eq_idx = 0;
    for i in 1..7 {
        if guess[i] as u64 > 9 {
            ops[j] = guess[i];
            j += 1;
        }

        if guess[i] == 14 {
            eq_idx = i;
        }

    }
    
    // Verify last operator is an equal sign
    assert((ops[2] == 14) | ((ops[1] == 14) & (ops[2] == 0)));
    // Get the total on the right side of the equals sign
    let mut total = 0;
    for i in 0..8 {
        if i > eq_idx as u64 {
            total = total * 10 + guess[i];
        }
    }

    // Combine all numbers between operators before equals sign (max amount is 3)
    let mut numbers: [Field] = [0; 3];
    // Combine numbers and append to numbers list every time an operator is hit.
    // Right side of equal sign is dropped because its the last operator.
    let mut number_idx = 0;
    let mut sum = 0;
    for i in 0..8  {
        if guess[i] as u64 < 10 {
            sum = sum * 10 + guess[i];
        } else {
            numbers[number_idx] = sum;
            sum = 0;
            number_idx += 1;
        }
    }

    let mut final = 0;

    // Calculate the multiplication and division
    // Multiply by inverse if division
    for i in 0..3 {
        // Mult
        if ops[i] == 12 {
            numbers[i+1] = numbers[i] * numbers[i+1];
            final = numbers[i+1];
            std::println("mult")
        }
        // Div
        if ops[i] == 13 {
            numbers[i+1] = numbers[i] / numbers[i+1];
            final = numbers[i+1];
            std::println("div")
        }
        
    }

    // Calculate the additions and subtractions
    for i in 0..3 {
        // Add
        if ops[i] == 10 {
            numbers[i+1] = numbers[i] + numbers[i+1];
            final = numbers[i+1];
            std::println("add")
        }
        // Sub
        if ops[i] == 11 {
            numbers[i+1] = numbers[i] - numbers[i+1];
            final = numbers[i+1];
            std::println("sub")
        }
        
    }

    //std::println(final);
    //std::println(total);

    // Check equal to total
    assert(final == total);

    true

}

// Compare guess to private answer and returns score
fn compare_guess(mut guess: [Field; 8], mut solution:[Field; 8]) -> [Field; 8] {
    // Create an array for each box in the game
    let mut guess_result: [Field; 8] = [0, 0, 0, 0, 0, 0, 0, 0];

    for i in 0..8 {
        for j in 0..8 {
            if (solution[j] == guess[i]) {
                    // Character is in the solution (Yellow)
                    guess_result[i] = 1;
            }
        }
    }

    for i in 0..8 {
        if (solution[i] == guess[i]) {
            // Character is correct (Green)
            guess_result[i] = 2;
        }
    }

    guess_result
}

#[test]
fn testmain() {
    // 1 + 1 + 9 = 11
    let guess = [1, 10, 1, 10, 9, 14, 1, 1];
    // 1 + 1 + 9 = 11
    let solution = [1, 10, 1, 10, 9, 14, 1, 1];
    let solution_hash = std::hash::pedersen(solution)[0];
    main(guess, solution, solution_hash) 
}
