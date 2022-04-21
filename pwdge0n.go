package main

import (
    "fmt"
    //"os"
    "math/rand"
    "time"
)

var lower= []string{"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"}
var upper= []string{"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
var numbers= []string{"0","1","2","3","4","5","6","7","8","9"}
var symbols= []string{"~",".",":","-","_",",",";","<",">","\"","|","!","\\","£","$","%","&","/","(",")","=","?","^","+","*","§","@","#","[","]","#","{","}"}
var red_symbols= []string{"-","_","|","!","£","$","%","&","=","?","^","+","*","§","@","#","#"}

func show_help(){
}

func genPass() {

}

func main() {
    fmt.Printf("%d\n", rand.Intn(20))
}
