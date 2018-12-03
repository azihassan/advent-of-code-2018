package main

import (
    "fmt"
    "bufio"
    "os"
)

func main() {
    scanner := bufio.NewScanner(os.Stdin)
    threes := 0
    twos := 0
    for scanner.Scan() {
        threeCount, twoCount := CountRepetitions(scanner.Text())
        threes += threeCount
        twos += twoCount
    }
    fmt.Println(threes * twos)
}

func CountRepetitions(word string) (int, int) {
    characterCount := make(map[rune]int)
    threeFound := 0
    twoFound := 0

    for _, char := range word {
        characterCount[char] += 1
    }


    for _, count := range characterCount {
        if count == 3 {
            threeFound = 1
        } else if count == 2 {
            twoFound = 1
        }
    }

    return twoFound, threeFound
}
