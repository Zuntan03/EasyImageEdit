@echo off
chcp 65001 > NUL
@REM Windows のエクスプローラでの名前ソート昇順

call %~dp0diffusion_models\ZIT\z-image-turbo_fp8_scaled_e4m3fn_KJ.bat

call %~dp0text_encoders\qwen3_4b_fp8_scaled.bat

call %~dp0vae\ae.bat
