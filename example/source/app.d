extern (C): // disable d mangling

import ldc.attributes;

void _start() { /* required module entrypoint */ }

@llvmAttr("wasm-import-module", "math") {
	int add(int a, int b);
}

int my_sum = 0;

export void setup() {
	// called on the first tick, or when the module is reloaded
	my_sum = 0;
}

export void tick() {
	// called on every tick
	my_sum = add(my_sum, 1);
}
