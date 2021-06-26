package main

import (
	"testing"

	"golang.org/x/example/stringutil"
)

func TestReverse(t *testing.T) {
	s := "this will be reversed"
	d := "desrever eb lliw siht"
	if stringutil.Reverse(s) == d {
		t.Log("Success")
	} else {
		t.Errorf("Reverse failed")
	}
}
