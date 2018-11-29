import torch

torch.ops.load_library("example_app/build/warp_perspective/libwarp_perspective.so")


def compute(x, y, z):
    x = torch.ops.my_ops.warp_perspective(x, torch.eye(3))
    return x.matmul(y) + torch.relu(z)


inputs = [torch.randn(4, 8), torch.randn(8, 5), torch.randn(8, 5)]
trace = torch.jit.trace(compute, inputs)
print(trace.graph)
