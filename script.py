import torch

torch.ops.load_library("example_app/build/warp_perspective/libwarp_perspective.so")


@torch.jit.script
def compute(x, y):
    if bool(x[0][0] == 42):
        z = 5
    else:
        z = 10
    x = torch.ops.my_ops.warp_perspective(x, torch.eye(3))
    return x.matmul(y) + z


print(compute.graph)
print(compute(torch.randn(4, 8), torch.randn(8, 5)))

compute.save("example.pt")
