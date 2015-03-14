Array.prototype.sum = function() {
	var i;
	var s:Number = 0;
	for (i=0; i < this.length; i++) {
		s += Number(this[i]);
	}
	return s;
}

var test = new Array(1, 2, 3);

console.print("Sum of Array(1, 2, 3) == 6: " + (test.sum() == 6));