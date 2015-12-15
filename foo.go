package main

import (
	"fmt"
	"sync"
)

func main() {
	c := make(chan string, 5)
	w := sync.WaitGroup{}
	w.Add(1); go func() { v, ok := <-c; fmt.Printf("done %s %t\n", v, ok); w.Done() }()
	w.Add(1); go func() { v, ok := <-c; fmt.Printf("done %s %t\n", v, ok); w.Done() }()
	w.Add(1); go func() { v, ok := <-c; fmt.Printf("done %s %t\n", v, ok); w.Done() }()
	c<-"foo"
	//c<-"foo"
	//c<-"foo"
	//c<-"foo"
	//c<-"foo"
	//c<-"foo"
	close(c)
	fmt.Println("closed")
	w.Add(1); go func() { v, ok := <-c; fmt.Printf("done %s %t\n", v, ok); w.Done() }()
	w.Add(1); go func() { v, ok := <-c; fmt.Printf("done %s %t\n", v, ok); w.Done() }()
	w.Add(1); go func() { v, ok := <-c; fmt.Printf("done %s %t\n", v, ok); w.Done() }()
	w.Add(1); go func() { v, ok := <-c; fmt.Printf("done %s %t\n", v, ok); w.Done() }()
	w.Add(1); go func() { v, ok := <-c; fmt.Printf("done %s %t\n", v, ok); w.Done() }()
	w.Wait()
}
