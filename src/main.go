package main

import (
	"fmt"
	"log"
	"net/http"
	"html"
)


func main() {
	fmt.Println("Hello world!")
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, %q", html.EscapeString(r.URL.Path))
	})
	log.Fatal(http.ListenAndServe(":80", nil))
}
