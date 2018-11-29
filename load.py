import torch
import torch.utils.cpp_extension

torch.utils.cpp_extension.load(
    name="warp_perspective",
    sources=["example_app/warp_perspective/op.cpp"],
    extra_ldflags=["-lopencv_core", "-lopencv_imgproc"],
    is_python_module=False,
    verbose=True
)

print(torch.ops.my_ops.warp_perspective)
