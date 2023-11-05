extern (C): // disable d mangling

import ldc.attributes;

import see;

void _start() { /* required module entrypoint */ }

// @llvmAttr("wasm-import-module", "math") {
// 	int add(int a, int b);
// }

export int add(int a, int b) {
	return a + b;
}

export int add_using_see(int a, int b) {
	return see_add(a, b);
}
