use dep::std;

fn main(guess: pub [Field; 8], solution:[Field; 8], solution_hash: pub Field) {
    // Returns result of players guess (1:Yellow: in solution, 2:Green: correct guess)
    let result: [Field; 8] = check_guess(guess, solution);
    // Checks hash of the solution is unchanged
    let hash = std::hash::pedersen(solution)[0];
    assert(solution_hash == hash);
    // Checks if guess is valid
    assert(check_valid(guess));

    // Check if guess is mathematically valid
    // For each number character (0 - 9) in sequence until next operator:
    //      Assign a field variable
    //      Multiply 10 and add current character
    // When you hit an operator in sequence, get the next number as well and address lookup table and call proper operator
    // If char is 14 Subtract right side  of '=' from total, should be zero.
    
    // (NOTE): We'll have to remember to consider BEDMAS and proper order of operations somehow
    // (NOTE): It's likely possible an attacker could bruteforce the solution from the hash
    //          We might have to include some randomness or some way to prevent that.

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
        // If symbols is equals sign iterate equals
        if guess[i] == 14 {
            equals += 1;
        }
    }
    // Verify theres a single equal sign (14) and it's the final operator
    assert(equals == 1);
    // Verify 14 is not last character in sequence.
    assert(guess[7] != 14);
    // Verify first character isn't an operator (10, 11, 12, 13, 14)
    assert(guess[0] as u64 < 10);
    true
}


fn check_guess(mut guess: [Field; 8], mut solution:[Field; 8]) -> [Field; 8] {
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
    let guess = [1, 11, 5, 10, 1, 2, 14, 8];
    let solution = [1, 10, 1, 10, 9, 14, 1, 1];
    let solution_hash = std::hash::pedersen(solution)[0];
    main(guess, solution, solution_hash) 
}

// 0 = 0
// 1 = 1
// 2 = 2
// 3 = 3
// 4 = 4
// 5 = 5
// 6 = 6
// 7 = 7
// 8 = 8
// 9 = 9
// + = 10
// - = 11
// * = 12
// / = 13
// = = 14
