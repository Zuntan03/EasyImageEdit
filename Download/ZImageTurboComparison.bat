@echo off
chcp 65001 > NUL
@REM Windows のエクスプローラでの名前ソート昇順

call %~dp0diffusion_models\ZIT\z_image_turbo_bf16.bat
call %~dp0diffusion_models\ZIT\z_image_turbo_bf16-DF11.bat
call %~dp0diffusion_models\ZIT\z_image_turbo-Q6_K.bat
call %~dp0diffusion_models\ZIT\z-image-turbo_fp8_scaled_e4m3fn_KJ.bat

call %~dp0text_encoders\qwen_3_4b.bat
call %~dp0text_encoders\qwen3_4b_fp8_scaled.bat
call %~dp0text_encoders\Qwen3-4B-IQ4_NL.bat

call %~dp0vae\ae.bat
