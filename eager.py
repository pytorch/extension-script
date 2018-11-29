import torch
torch.ops.load_library("example_app/build/warp_perspective/libwarp_perspective.so")
print(torch.ops.my_ops.warp_perspective(torch.randn(32, 32), torch.rand(3, 3)))
