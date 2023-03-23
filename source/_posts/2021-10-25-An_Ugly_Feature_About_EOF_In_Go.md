---
title: An ugly feature about io.EOF in Go
date: 2021-10-25 00:17:40
tags: 
- lang_english
- programming
- go_lib
- golang
---
`io.EOF` seems to be a weird feature in Go. This article will explain **WHY**.

### <b>ch1. What is io.EOF</b>
`io.EOF` is a basic statement used by Go programming in a high frequency. We can find out it's definition and documents easily by reading the source code and using `go doc`. Here's the code:
```go
// =====io.go==========================================
// ...
// EOF is the error returned by Read when no more input is available.
// (Read must return EOF itself, not an error wrapping EOF,  
// because callers will test for EOF using ==.)
// Functions should return EOF only to signal a graceful end of input.
// If the EOF occurs unexpectedly in a structured data stream,
// the appropriate error is either ErrUnexpectedEOF or some other error// giving more detail.  
var EOF = errors.New("EOF")
// =====errors.go=========================================
package io
// ...
func New(text string) error {  
   return &errorString{text}  
}  
  
// errorString is a trivial implementation of error.type errorString struct {  
   s string  
}  
 
func (e *errorString) Error() string {  
   return e.s  
}
```

### <b>ch2. How ugly it is</b>
`io.EOF` is one of the most important variables in Go. It identifies the end of an `io.Stand_input`. Cause every file has an end, `io.EOF` normally does not mean an actual error, instead of it, just an ending message. However, `io.EOF` was implemented in a dirty way. It is actually a implicit cast according to it's source code. We can see the abbreviation `EOF`, which means `End-Of-File`. It is the abbreviation of a variable rather than const or something else according to the abbr principles made by Go itself. This will lead into an overlooked danger of API permission diffusions while Minimizing API permission is the highest target of a common programming language. For example, an important safety design of Go is to prohibit implicit type casting. Therefore, with this design, we can easily find bugs in the program. In addition, Go prohibits the definition of local variables that are not used (except for function parameters, so function parameters are one part of the functional interface) and prohibiting the import of unused packages are the best practices for minimizing permissions. The design of these minimum API permissions not only improves the quality of the program, but also improves the performance of the compilation tool and the output object file Because `io.EOF` is defined as a variable, it could be maliciously tampered with. Here is an intuitive case：
```go
func  init() {
	io.EOF =  nil
}
```
### <b>ch3. Can we make it more safer?</b>
The answer is `YES`. An obvious improvement is to define io.EOF as a constant. But because EOF corresponds to an error interface type, and the current constant syntax of the Go does not support interfaces that defined in constant types. But we can bypass this restriction through some tricks . Constants in Go have a main types of bool/int/float/string/nil. Constants do not only exclude complex types such as interfaces, and even constant arrays or structures are not supported! However, constants have an important extension rule: New types defined based on bool/int/float/string/nil also support constants. The codeblock shown below is a simple case of that kind of tricks.
```go
type  MyString  string
const  name MyString =  "Kivinsae"
```
Following this case, we can rewrite the errorString function of `package io` and make `io.EOF` an essential const hidden in the surface of normal interface:
```go
// =====errors.go===================================
package  io
type  errorString  string
func  (e errorString) Error()  string  {
	return  string(e)
}
// =====io.go=======================================
const EOF = errorString( "EOF" )
4
```