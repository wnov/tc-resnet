#!/usr/bin/env bash
trap 'pkill -P $$' SIGINT SIGTERM EXIT
python train_audio.py --dataset_path google_speech_commands/splitted_data --dataset_split_name train --output_name output/softmax --num_classes 12 --train_dir work/v1/DSCNNLModel-0/mfcc_10_4020_0.0000_adam_l3 --num_silent 1854 --augmentation_method anchored_slice_or_pad_with_shift --preprocess_method mfcc --num_mfccs 10 --clip_duration_ms 1000 --window_size_ms 40 --window_stride_ms 20 --batch_size 100 --boundaries 10000 --max_step_from_restore 20000 --lr_list 0.0005 0.0001 --absolute_schedule --no-boundaries_epoch --max_to_keep 20 --step_save_checkpoint 500 --step_evaluation 500 --optimizer adam DSCNNLModel &
sleep 5
python evaluate_audio.py --dataset_path google_speech_commands/splitted_data --dataset_split_name valid --output_name output/softmax --num_classes 12 --checkpoint_path work/v1/DSCNNLModel-0/mfcc_10_4020_0.0000_adam_l3 --num_silent 258 --augmentation_method anchored_slice_or_pad --preprocess_method mfcc --num_mfccs 10 --clip_duration_ms 1000 --window_size_ms 40 --window_stride_ms 20 --background_frequency 0.0 --background_max_volume 0.0 --max_step_from_restore 20000 --batch_size 3 --no-shuffle --valid_type loop DSCNNLModel &
wait
python evaluate_audio.py --dataset_path google_speech_commands/splitted_data --dataset_split_name test --output_name output/softmax --num_classes 12 --checkpoint_path work/v1/DSCNNLModel-0/mfcc_10_4020_0.0000_adam_l3/valid/accuracy/valid --num_silent 257 --augmentation_method anchored_slice_or_pad --preprocess_method mfcc --num_mfccs 10 --clip_duration_ms 1000 --window_size_ms 40 --window_stride_ms 20 --background_frequency 0.0 --background_max_volume 0.0 --max_step_from_restore 20000 --batch_size 39 --no-shuffle --valid_type once DSCNNLModel