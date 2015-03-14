package
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	
	import mx.controls.TextArea;
	
	public class TextAreaExtended extends TextArea
	{
		public var pasteCommand:Boolean = false; 
		
		public function TextAreaExtended()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(TextEvent.TEXT_INPUT, textInputHandler); 
    		addEventListener(KeyboardEvent.KEY_DOWN, keyboardHandler); 
		}
		
		private function addedToStage(event:Event):void
		{
    			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown, false, 0, true);
		}
		
		// Workaround for shift+space bug
		// If shift and space are being held down together
		private function keyDown(event:KeyboardEvent):void
		{
			if(stage && stage.focus != textField) return;
			
			if (event.keyCode == 32 && event.shiftKey)
			{
				// ... add the space at the current location.
				var caretIndex:int = textField.caretIndex;
				var firstPart:String = textField.text.substr(0, caretIndex);
				var secondPart:String = textField.text.substr(caretIndex, textField.length);
				var newString:String = firstPart + ' ' + secondPart;
				textField.text = newString;	
	
				var newCaretIndex:uint = caretIndex + 1;
	
				textField.setSelection(newCaretIndex, newCaretIndex);
			}
		}
		
		/**
		 * Handle when a key is pressed.
		 * If the user is pressing ctrl-v then set
		 * <code>pasteCommand</code> to true.
		 * 
		 * @param event The event that triggered this function.
		 * 
		 * @see #pasteCommand
		 */
        	private function keyboardHandler(event:KeyboardEvent):void
        	{	
        		if(event.ctrlKey == true && event.keyCode == 17) 
        			pasteCommand = true;
			}
        
        	/**
         	 * Handle when the text has been input.
         	 * If the user pasted this text in, then prevent the default
         	 * processing so that the text can be pasted correctly.
         	 * 
         	 * @param event The event that triggered the function.
         	 */
        	private function textInputHandler(event:TextEvent):void
        	{ 
        		if(pasteCommand){ 
        			event.preventDefault();
        		
			    	var textField:TextArea = event.target as TextArea;
			    	var currentText:String = textField.text;
			    	var insertionPrefix:String = currentText.substr(0, textField.selectionBeginIndex);
			   	 var insertionSuffix:String = currentText.substr(textField.selectionEndIndex, currentText.length);
			    	textField.text = insertionPrefix + event.text + insertionSuffix;
			    	var caretIndex:int = insertionPrefix.length + event.text.length;
			    	textField.setSelection(caretIndex, caretIndex);  
			        		
        			pasteCommand = false;
        		}
        	}
	}
}
