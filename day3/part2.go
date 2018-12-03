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

    for i, a := range rects {
        overlap := false
        for j, b := range rects {
            if i != j && Overlap(&a, &b) {
                overlap = true
                break
            }
        }

        if !overlap {
            fmt.Printf("Found match : %d\n", rects[i].Id)
        }
    }
}

func ParseRect(input string) Rect {
    var rect Rect
    fmt.Sscanf(input, "#%d @ %d,%d: %dx%d", &rect.Id, &rect.Left, &rect.Top, &rect.Width, &rect.Height)
    return rect
}

func (rect *Rect) String() string {
    return fmt.Sprintf("#%d @ %d,%d: %dx%d", rect.Id, rect.Left, rect.Top, rect.Width, rect.Height)
}

func (a *Rect) Covers (b *Rect) bool {
    if a.Left + a.Width < b.Left {
        return false
    }
    if a.Top + a.Height < b.Top {
        return false
    }
    if b.Left + b.Width < a.Left {
        return false
    }
    if b.Top + b.Height < a.Top {
        return false
    }
    return true
}

func Overlap(a *Rect, b *Rect) bool {
    return a.Covers(b)
}
