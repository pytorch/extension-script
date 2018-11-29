# Run `python setup.py build develop` before running this example!

import torch
torch.ops.load_library("warp_perspective.so")
print(torch.ops.my_ops.warp_perspective)
