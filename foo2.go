package main

func main() {
	c := make(chan string, 1)
	c<-"foo"
	<-c
}
