package main

import (
  "net/http"
  "net/http/httptest"
  "testing"
)

func TestHello(t *testing.T) {
  req, err := http.NewRequest("GET", "/health-check", nil)
  if err != nil {
    t.Fatal(err)
  }
  recorder := httptest.NewRecorder()
  handler := http.HandlerFunc(Hello)
  handler.ServeHTTP(recorder, req)
  if status := recorder.Code; status != http.StatusOK {
    t.Errorf("Wrong status code returned by handler: got %v wanted %v", status, http.StatusOK)
  }
  expected := `Hello, world !`
  if recorder.Body.String() != expected {
    t.Errorf("The body returned is unexpected: got %v wanted %v", recorder.Body.String(), expected)
  }
}
