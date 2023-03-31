// hello-go-deploy-gce main.go

package main

import (
	"testing"
)

func Test_addThis(t *testing.T) {
	type args struct {
		a int
		b int
	}
	tests := []struct {
		name     string
		args     args
		wantTemp int
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if gotTemp := addThis(tt.args.a, tt.args.b); gotTemp != tt.wantTemp {
				t.Errorf("addThis() = %v, want %v", gotTemp, tt.wantTemp)
			}
		})
	}
}

func Test_main(t *testing.T) {
	tests := []struct {
		name string
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			main()
		})
	}
}

func Test_checkErr(t *testing.T) {
	type args struct {
		err error
	}
	tests := []struct {
		name string
		args args
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			checkErr(tt.args.err)
		})
	}
}

func Test_checkVersion(t *testing.T) {
	type args struct {
		version bool
	}
	tests := []struct {
		name string
		args args
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			checkVersion(tt.args.version)
		})
	}
}

func Test_setLogLevel(t *testing.T) {
	type args struct {
		debugTrace bool
	}
	tests := []struct {
		name string
		args args
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			setLogLevel(tt.args.debugTrace)
		})
	}
}

func Test_count(t *testing.T) {
	tests := []struct {
		name string
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			count()
		})
	}
}
