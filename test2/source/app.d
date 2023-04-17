module app;

extern (C): // disable d mangling

import ldc.attributes;

// @llvmAttr("wasm-import-module", "math") {
// 	int add(int a, int b);
// }
@llvmAttr("wasm-import-module", "test1") {
	int add(int a, int b);
}

class ATypeBean {
	int val;
	this(int val) {
		this.val = val;
	}

	int get_bean_number() {
		return add(100, val);
	}
}

class BasedBean : ATypeBean {
	this() {
		super(0);
	}

	override int get_bean_number() {
		return add(super.get_bean_number(), 100);
	}
}

int my_state = 0;

export void init() {
	// auto my_bean = new BasedBean();
	// my_state = my_bean.get_bean_number();
}

// export int random_number() {
// 	import std.random;

// 	return std.random.uniform(0, 100);
// }

export void tick() {
	my_state = add(my_state, 1);
}

export int get_state() {
	return my_state;
}
