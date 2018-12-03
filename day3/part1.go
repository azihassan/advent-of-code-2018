package main

import (
    "fmt"
    "bufio"
    "os"
)

type Rect struct {
    Id int
    Left int
    Top int
    Width int
    Height int
}

func main() {
    scanner := bufio.NewScanner(os.Stdin)
    rects := make([]Rect, 0)
    for scanner.Scan() {
        rect := ParseRect(scanner.Text())
        rects = append(rects, rect)
    }

    width, height := BoardSize(rects)
    board := make([][]int, height)
    for i, _ := range board {
        board[i] = make([]int, width)
    }

    for _, rect := range rects {
        rect.Draw(board)
    }

    overlapping := 0
    for _, row := range board {
        overlapping += Count(row, 2)
    }

    fmt.Printf("Overlapping inches : %d\n", overlapping)
}

//does golang not have a count function ?
func Count(haystack []int, needle int) int {
    count := 0
    for _, value := range haystack {
        if value == needle {
            count++
        }
    }
    return count
}

func ParseRect(input string) Rect {
    var rect Rect
    fmt.Sscanf(input, "#%d @ %d,%d: %dx%d", &rect.Id, &rect.Left, &rect.Top, &rect.Width, &rect.Height)
    return rect
}

func (rect *Rect) String() string {
    return fmt.Sprintf("#%d @ %d,%d: %dx%d", rect.Id, rect.Left, rect.Top, rect.Width, rect.Height)
}

func (rect *Rect) Draw(board [][]int) {
    for y := rect.Top; y < rect.Top + rect.Height; y++ {
        for x := rect.Left; x < rect.Left + rect.Width; x++ {
            if board[y][x] != 0 {
                board[y][x] = 2
            } else {
                board[y][x] = 1
            }
        }
    }
}

func BoardSize(rects []Rect) (int, int) {
    startX := rects[0].Left
    startY := rects[0].Top
    endX := rects[0].Left + rects[0].Width
    endY := rects[0].Top + rects[0].Height

    for _, rect := range rects {
        if rect.Left < startX {
            startX = rect.Left
        }
        if rect.Top < startY {
            startY = rect.Top
        }
        if rect.Left + rect.Width > endX {
            endX = rect.Left + rect.Width
        }
        if rect.Top + rect.Height > endY {
            endY = rect.Top + rect.Height
        }
    }
    return endX - startX + 1, endY - startY + 1
}
