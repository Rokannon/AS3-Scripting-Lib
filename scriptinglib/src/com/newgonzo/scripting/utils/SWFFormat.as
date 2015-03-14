package com.newgonzo.scripting.utils
{
	import flash.display.Loader;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class SWFFormat
	{
		private static const SWF_START:Array = 
		[
			0x46, 0x57, 0x53, 0x09,
			0xff, 0xff, 0xff, 0xff,
			0x78, 0x00, 0x03, 0xe8, 0x00, 0x00, 0x0b, 0xb8, 0x00,
			0x00, 0x0c, 0x01, 0x00,
			0x44, 0x11,  
			0x08, 0x00, 0x00, 0x00
		];
		
		private static const ABC_HEADER:Array =
		[
			0x3f, 0x12
		];
		
		private static const SWF_END:Array = 
		[
			0x40, 0x00
		]; 
		
		
		public static function makeSWF(abcByteArrays:Array):ByteArray
		{
			var out:ByteArray = new ByteArray();
			out.endian = Endian.LITTLE_ENDIAN;
			
			for (var i:int = 0; i < SWF_START.length; i++)
			{
				out.writeByte(SWF_START[i]);
			}
			
			for (i = 0; i < abcByteArrays.length; i++)
			{
				var abc:ByteArray = abcByteArrays[i];
				
				for (var j:int = 0; j < ABC_HEADER.length; j++)
				{
					out.writeByte(ABC_HEADER[j]);
				}
				
				// set ABC length
				out.writeInt(abc.length);
				out.writeBytes(abc, 0, abc.length);
			}
			
			for (i = 0; i < SWF_END.length; i++)
			{
				out.writeByte(SWF_END[i]);
			}
			
			// set SWF length
			out.position = 4;
			out.writeInt(out.length);
			// reset
			out.position = 0;
			return out;
		}
		
		public static function getType(data:ByteArray):int
		{
			data.endian = Endian.LITTLE_ENDIAN;
			var version:uint = data.readUnsignedInt()
			
			switch (version)
			{
				case 46<<16|14:
				case 46<<16|15:
				case 46<<16|16:
					return 2;
				case 67|87<<8|83<<16|9<<24: // SWC9
				case 67|87<<8|83<<16|8<<24: // SWC8
				case 67|87<<8|83<<16|7<<24: // SWC7
				case 67|87<<8|83<<16|6<<24: // SWC6
					return 5;
				case 70|87<<8|83<<16|9<<24: // SWC9
				case 70|87<<8|83<<16|8<<24: // SWC8
				case 70|87<<8|83<<16|7<<24: // SWC7
				case 70|87<<8|83<<16|6<<24: // SWC6
				case 70|87<<8|83<<16|5<<24: // SWC5
				case 70|87<<8|83<<16|4<<24: // SWC4
					return 1;
				default:
					return 0;
			}
		}
	}
}
