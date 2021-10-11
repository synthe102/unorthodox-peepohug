package main

import (
  "io"
  "net/http"
  "os"
)

func main() {
  http.HandleFunc("/", Hello)
  http.ListenAndServe(":8080", nil)
}

func Hello(res http.ResponseWriter, req *http.Request) {
  backend, _ := os.Hostname()
  res.Header().Set("Backend-Server", backend)
  io.WriteString(res, `Hello, world !`)
}
