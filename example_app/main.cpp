#include <torch/script.h> // One-stop header.

  #include <iostream>
  #include <memory>


  int main(int argc, const char* argv[]) {
    if (argc != 2) {
      std::cerr << "usage: example-app <path-to-exported-script-module>\n";
      return -1;
    }
 
    // Deserialize the ScriptModule from a file using torch::jit::load().
    torch::jit::script::Module module = torch::jit::load(argv[1]);

    std::vector<torch::jit::IValue> inputs;
    inputs.push_back(torch::randn({4, 8}));
    inputs.push_back(torch::randn({8, 5}));

    torch::Tensor output = module.forward(std::move(inputs)).toTensor();

    std::cout << output << std::endl;
  }
