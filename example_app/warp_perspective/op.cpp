#include <opencv2/opencv.hpp>
#include <torch/script.h>

torch::Tensor warp_perspective(torch::Tensor image, torch::Tensor warp) {
  cv::Mat image_mat(/*rows=*/image.size(0),
                    /*cols=*/image.size(1),
                    /*type=*/CV_32FC1,
                    /*data=*/image.data<float>());
  cv::Mat warp_mat(/*rows=*/warp.size(0),
                   /*cols=*/warp.size(1),
                   /*type=*/CV_32FC1,
                   /*data=*/warp.data<float>());

  cv::Mat output_mat;
  cv::warpPerspective(image_mat, output_mat, warp_mat, /*dsize=*/{8, 8});

  torch::Tensor output =
    torch::from_blob(output_mat.ptr<float>(), /*sizes=*/{8, 8});
  return output.clone();
}

static auto registry =
  torch::RegisterOperators("my_ops::warp_perspective", &warp_perspective);
