package main

import (
  "io"
  "net/http"
  "os"
)

func main() {
  http.HandleFunc("/", Hello)
  err := http.ListenAndServe(":8080", nil)
  if err != nil {
    panic(err)
  }
}

func Hello(res http.ResponseWriter, req *http.Request) {
  backend, _ := os.Hostname()
  res.Header().Set("Backend-Server", backend)
  io.WriteString(res, `Hello, world !`)
}
