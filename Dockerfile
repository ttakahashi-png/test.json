# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.0-base

# 1. 声明构建参数 (ARG)
# 这一步是必须的，否则后面的 RUN 指令无法读取到 HF_TOKEN
ARG HF_TOKEN

# 2. 安装 huggingface_hub
RUN pip install --no-cache-dir huggingface_hub

# 3. 安装 Custom Nodes (保持不变)
RUN comfy node install --exit-on-fail was-ns@3.0.1
RUN comfy node install --exit-on-fail comfyui-impact-pack@8.28.0

# 4. 下载公开模型 (使用 comfy cli 或 huggingface-cli 均可，这里保持原样)
RUN comfy model download --url https://huggingface.co/Kim2091/AnimeSharp/resolve/main/4x-AnimeSharp.pth --relative-path models/upscale_models --filename 4x-AnimeSharp.pth
RUN comfy model download --url https://huggingface.co/Drditone/VAE/tree/main --relative-path models/vae --filename liquid111vae_sdxl9745VAE.safetensors

# 5. 下载私有库模型 (使用传入的 HF_TOKEN)
# 仓库 ID: TakaT20251120/safetensors-mirror-saves

# [Lora] Eyes_for_Illustrious...
# 直接引用 $HF_TOKEN 环境变量
RUN huggingface-cli download \
    --token $HF_TOKEN \
    TakaT20251120/safetensors-mirror-saves \
    Eyes_for_Illustrious_Lora_Perfect_anime_eyes.safetensors \
    --local-dir /comfyui/models/loras \
    --local-dir-use-symlinks False

# [Checkpoint] novaAnimeXL...
RUN huggingface-cli download \
    --token $HF_TOKEN \
    TakaT20251120/safetensors-mirror-saves \
    novaAnimeXL_ilV125.safetensors \
    --local-dir /comfyui/models/checkpoints \
    --local-dir-use-symlinks False

# copy all input data (like images or videos) into comfyui
# COPY input/ /comfyui/input/