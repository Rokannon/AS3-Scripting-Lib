var dict = new flash.utils.Dictionary();

var key = new Object();
var value = "test";

dict[key] = value;
dict[value] = key;

console.print("dict[key] == value: " + (dict[key] == value));
console.print("dict[value] == key: " + (dict[value] == key));