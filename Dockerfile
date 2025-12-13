# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.0-base

# install custom nodes into comfyui
RUN comfy node install --exit-on-fail was-ns@3.0.1
RUN comfy node install --exit-on-fail comfyui-impact-pack@8.28.0

# download models into comfyui
RUN comfy model download --url https://huggingface.co/Kim2091/AnimeSharp/resolve/main/4x-AnimeSharp.pth --relative-path models/upscale_models --filename 4x-AnimeSharp.pth
RUN comfy model download --url https://huggingface.co/Drditone/VAE/tree/main --relative-path models/vae --filename liquid111vae_sdxl9745VAE.safetensors
RUN comfy model download --url https://www.runninghub.ai/model/public/1956000679536066561 --relative-path models/loras --filename Eyes_for_Illustrious_Lora_Perfect_anime_eyes.safetensors
# RUN # Could not find URL for novaAnimeXL_ilV130.safetensors

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/
