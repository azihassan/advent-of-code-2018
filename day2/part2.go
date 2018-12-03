package main

import (
    "fmt"
    "bufio"
    "os"
)

func main() {
    scanner := bufio.NewScanner(os.Stdin)
    words := make([]string, 0)
    for scanner.Scan() {
        words = append(words, scanner.Text())
    }
    fmt.Println(words)


    lowestScore := len(words[0])
    firstID := ""
    secondID := ""
    for i := 0; i < len(words); i++ {
        for j := i + 1; j < len(words); j++ {
            score := CountDifferences(words[i], words[j])
            if score < lowestScore {
                lowestScore = score
                firstID = words[i]
                secondID = words[j]
            }
        }
    }

    fmt.Printf("%s %s %s\n", firstID, secondID, CommonLetters(firstID, secondID))
}

func CommonLetters(a string, b string) string {
    common := ""
    for i, _ := range(a) {
        if a[i] == b[i] {
            common += string(a[i])
        }
    }
    return common
}

func CountDifferences(a string, b string) int {
    count := 0
    for i, _ := range(a) {
        if a[i] != b[i] {
            count++
        }
    }
    return count
}
