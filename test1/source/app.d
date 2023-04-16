extern (C): // disable d mangling

import ldc.attributes;

void _start() { /* required module entrypoint */ }

// @llvmAttr("wasm-import-module", "math") {
// 	int add(int a, int b);
// }

export int add(int a, int b) {
	return a + b;
}
