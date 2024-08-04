from bark import SAMPLE_RATE, generate_audio
from IPython.display import Audio
from scipy.io.wavfile import write as write_wav
import gradio as gr
import os 

voicePath = "bark/assets/prompts"
contents = os.listdir(voicePath)
npz_files = []
for item in contents:
    if item.endswith(".npz"):
        npz_files.append(item)
    elif item == "v2":
        pathV2 = voicePath + "/v2"
        contentsV2 = os.listdir(pathV2)
        for itemV2 in contentsV2:
            if itemV2.endswith(".npz"):
                itemV2fname = "v2/" + itemV2
                npz_files.append(itemV2fname)

npz_names = sorted( [os.path.splitext(f)[0] for f in npz_files] )

print("\nStarting Suno-AI bark TTS WebUI\n")

def start(prompt, voice):
    print("\nStarting...")
    print(" Prompt : " + prompt)
    print(" Voice : " + (npz_names[voice] if voice is not None else "Default"))
    print()
    #prompt = '\n'.join(prompts)
    
    if voice == None:
        audio_array = generate_audio(prompt)
    else:   
        audio_array = generate_audio(prompt, history_prompt=npz_names[voice])
    
    output_dir = os.path.dirname(os.getcwd()) + "/outputs"
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    write_wav(f"{output_dir}/audio-output.wav", SAMPLE_RATE, audio_array)
    return f"{output_dir}/audio-output.wav"

with gr.Blocks() as demo:

    gr.Title="Bark TTS WebUI",
    gr.Markdown("Bark TTS WebUI")
    
    with gr.Row():

        prompts = gr.Textbox(label="Prompt", placeholder="Enter your text here", lines=4)

    with gr.Row():
        voice = gr.Dropdown(npz_names, type="index", label="Voice", info="Select the voice")
        generate_button = gr.Button("Generate")
  
    with gr.Column():
        output = gr.Audio(label="Result")
        
    generate_button.click(
        start,
        [prompts, voice],
        [output],
    )

demo.launch()