module app;

extern (C): // disable d mangling

import ldc.attributes;

void _start() { /* required module entrypoint */ }

// @llvmAttr("wasm-import-module", "math") {
// 	int add(int a, int b);
// }
@llvmAttr("wasm-import-module", "test1") {
	int add(int a, int b);
}

int my_state = 0;

export void tick() {
	my_state = add(my_state, 1);
}

export int get_state() {
	return my_state;
}
