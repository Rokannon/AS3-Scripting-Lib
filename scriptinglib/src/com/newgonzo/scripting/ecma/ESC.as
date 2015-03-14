package com.newgonzo.scripting.ecma
{
	import com.newgonzo.scripting.utils.SWFFormat;

	import flash.utils.ByteArray;

	public class ESC
    {
        [Embed(source="/../abc/debug.es.abc", mimeType="application/octet-stream")]
        private static const debug_abc:Class;

        [Embed(source="/../abc/util.es.abc", mimeType="application/octet-stream")]
        private static const util_abc:Class;

        [Embed(source="/../abc/bytes-tamarin.es.abc", mimeType="application/octet-stream")]
        private static const bytes_tamarin_abc:Class;

        [Embed(source="/../abc/util-tamarin.es.abc", mimeType="application/octet-stream")]
        private static const util_tamarin_abc:Class;

        [Embed(source="/../abc/lex-char.es.abc", mimeType="application/octet-stream")]
        private static const lex_char_abc:Class;

        [Embed(source="/../abc/lex-token.es.abc", mimeType="application/octet-stream")]
        private static const lex_token_abc:Class;

        [Embed(source="/../abc/lex-scan.es.abc", mimeType="application/octet-stream")]
        private static const lex_scan_abc:Class;

        [Embed(source="/../abc/ast.es.abc", mimeType="application/octet-stream")]
        private static const ast_abc:Class;

        [Embed(source="/../abc/define.es.abc", mimeType="application/octet-stream")]
        private static const define_abc:Class;

        [Embed(source="/../abc/parse.es.abc", mimeType="application/octet-stream")]
        private static const parse_abc:Class;

        [Embed(source="/../abc/asm.es.abc", mimeType="application/octet-stream")]
        private static const asm_abc:Class;

        [Embed(source="/../abc/abc.es.abc", mimeType="application/octet-stream")]
        private static const abc_abc:Class;

        [Embed(source="/../abc/abc-encode.es.abc", mimeType="application/octet-stream")]
        private static const abc_encode_abc:Class;

        [Embed(source="/../abc/abc-decode.es.abc", mimeType="application/octet-stream")]
        private static const abc_decode_abc:Class;

        [Embed(source="/../abc/emit.es.abc", mimeType="application/octet-stream")]
        private static const emit_abc:Class;

        [Embed(source="/../abc/cogen.es.abc", mimeType="application/octet-stream")]
        private static const cogen_abc:Class;

        [Embed(source="/../abc/cogen-stmt.es.abc", mimeType="application/octet-stream")]
        private static const cogen_stmt_abc:Class;

        [Embed(source="/../abc/cogen-expr.es.abc", mimeType="application/octet-stream")]
        private static const cogen_expr_abc:Class;

        [Embed(source="/../abc/esc-core.es.abc", mimeType="application/octet-stream")]
        private static const esc_core_abc:Class;

        [Embed(source="/../abc/eval-support.es.abc", mimeType="application/octet-stream")]
        private static const eval_support_abc:Class;

        [Embed(source="/../abc/esc-env.es.abc", mimeType="application/octet-stream")]
        private static const esc_env_abc:Class;

        [Embed(source="/../abc/sampler.es.abc", mimeType="application/octet-stream")]
        private static const sampler_abc:Class;

        [Embed(source="/../abc/esc.es.abc", mimeType="application/octet-stream")]
        private static const esc_abc:Class;

        private static var escSwfBytes:ByteArray;

        public static function get swfBytes():ByteArray
        {
            if (!escSwfBytes)
            {
                var abcByteArrays:Array = [new debug_abc as ByteArray, new util_abc as ByteArray, new bytes_tamarin_abc as ByteArray, new util_tamarin_abc as ByteArray, new lex_char_abc as ByteArray, new lex_token_abc as ByteArray, new lex_scan_abc as ByteArray, new ast_abc as ByteArray,

                    new define_abc as ByteArray,

                    new parse_abc as ByteArray, new asm_abc as ByteArray, new abc_abc as ByteArray,

                    new abc_encode_abc as ByteArray, new abc_decode_abc as ByteArray,

                    new emit_abc as ByteArray, new cogen_abc as ByteArray, new cogen_stmt_abc as ByteArray, new cogen_expr_abc as ByteArray, new esc_core_abc as ByteArray, new eval_support_abc as ByteArray, new esc_env_abc as ByteArray,

                    new sampler_abc as ByteArray, //new esc_abc as ByteArray
                ];

                escSwfBytes = SWFFormat.makeSWF(abcByteArrays);
            }

            return escSwfBytes;
        }
    }
}