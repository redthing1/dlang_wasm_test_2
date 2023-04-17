
// based on https://gist.github.com/kfl/d5f1463ebe1b7107aeb02e2f4089a28a

async function main() {
  // set up wasm env
  let env = {
    io: {
      print: (x) => console.log(x),
    },
    shared: {
      memory: new WebAssembly.Memory({initial: 1}),
      //   table : new WebAssembly.Table({ initial: 1, element: "anyfunc" }) //
      //   for indirect calls
    },
  };

  // instantiate modules via streaming

  // load module 1
  let module1Data = await fetch('test1/test1.wasm');
  let module1 = (await WebAssembly.instantiateStreaming(module1Data, env));

  // add exports from module 1 to environment
  env['test1'] = module1.instance.exports;

  // load module 2
  let module2Data = await fetch('test2/test2.wasm');
  let module2 = (await WebAssembly.instantiateStreaming(module2Data, env));

  // now, call stuff from module 2
  // test it out

  // call init
  module2.instance.exports.init();

  // call tick 3 times
  for (let i = 0; i < 3; i++) {
    module2.instance.exports.tick();
  }

  // check state
  let stateValue = module2.instance.exports.get_state();
  console.log(`from js: module2.instance.exports.get_state() = ${stateValue}`);

  // // try random number
  // let aRandomNumber = module2.instance.exports.random_number();
  // console.log(
  //     `from js: module2.instance.exports.random_number() = ${aRandomNumber}`);
}

main();
