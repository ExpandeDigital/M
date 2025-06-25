# M
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reproductor de Guion de Audio</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
        #play-button:disabled {
            background-color: #999;
            cursor: not-allowed;
        }
    </style>
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen p-4">

    <div class="w-full max-w-2xl bg-white rounded-xl shadow-lg p-8">
        <h1 class="text-2xl font-bold text-gray-800 mb-2">Guion para Audio</h1>
        <p class="text-gray-500 mb-6">Edita el texto a continuación y presiona el botón para escucharlo.</p>

        <textarea id="script-textarea" class="w-full h-64 p-4 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-shadow duration-200"
        >Hola, mi nombre es Cristian Jofré Donoso, Director de Marketing y Transformación Digital.

Me dirijo a ustedes con gran interés por la vacante de Director de Marketing. Dada mi trayectoria de más de una década como Director especializado en transformación digital y crecimiento empresarial, estoy seguro de que mi perfil es ideal para aportar valor a su organización.

A lo largo de mi carrera, he demostrado mi capacidad para generar resultados medibles. Como Director Internacional, implementé estrategias que lograron un crecimiento del 17% en el sector B2C y un 12% en el B2B. Mi enfoque no solo es estratégico, sino también ejecutivo: he liderado más de 500 proyectos digitales y desarrollado 7 soluciones de software que optimizaron la eficiencia interna en un 45%.

Estoy convencido de que mi experiencia integrando tecnologías como Inteligencia Artificial y Big Data con marketing puede contribuir directamente a sus objetivos corporativos y a fortalecer su posición en el mercado.

Agradezco mucho su tiempo y consideración. Quedo a su entera disposición para conversar sobre cómo mi visión estratégica puede impulsar el éxito de su equipo.

Cristian Jofré Donoso. Periodista y Máster en Marketing Digital y Analítica Web.
        </textarea>

        <div class="mt-6 flex justify-center">
            <button id="play-button" class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-8 rounded-full transition-transform transform hover:scale-105 flex items-center space-x-2">
                <svg id="play-icon" xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z" />
                </svg>
                <svg id="stop-icon" xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 hidden" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 10h6v4H9z" />
                </svg>
                <span id="button-text">Reproducir Audio</span>
            </button>
        </div>
         <p id="status-text" class="text-center text-gray-400 mt-4 text-sm h-5"></p>
    </div>

    <script>
        const playButton = document.getElementById('play-button');
        const buttonText = document.getElementById('button-text');
        const scriptTextarea = document.getElementById('script-textarea');
        const statusText = document.getElementById('status-text');
        const playIcon = document.getElementById('play-icon');
        const stopIcon = document.getElementById('stop-icon');

        let selectedVoice = null;
        let isPlaying = false;

        function loadAndSetVoice() {
            if (!('speechSynthesis' in window)) {
                 statusText.textContent = "Tu navegador no soporta la síntesis de voz.";
                 playButton.disabled = true;
                return;
            }
            const voices = speechSynthesis.getVoices();
            if (voices.length === 0) {
                 statusText.textContent = "Cargando voces...";
                return;
            };

            const spanishVoices = voices.filter(voice => voice.lang.startsWith('es'));
            const priorities = [
                voice => voice.lang === 'es-CL',
                voice => ['es-MX', 'es-US'].includes(voice.lang),
                voice => voice.lang.startsWith('es-'),
            ];
             for (const priority of priorities) {
                const matchedVoice = spanishVoices.find(priority);
                if (matchedVoice) {
                    selectedVoice = matchedVoice;
                    statusText.textContent = Voz lista: ${selectedVoice.name};
                    return;
                }
            }
            statusText.textContent = "No se encontró una voz preferida.";
        }
        
        function speak(text) {
            if (!('speechSynthesis' in window) || !text) {
                return;
            }
            
            isPlaying = true;
            updateButtonState();

            speechSynthesis.cancel();
            const utterance = new SpeechSynthesisUtterance(text);
            
            if (selectedVoice) {
                utterance.voice = selectedVoice;
            }
            utterance.lang = selectedVoice ? selectedVoice.lang : 'es-ES';
            utterance.rate = 0.9;
            
            utterance.onend = () => {
                isPlaying = false;
                updateButtonState();
            };

            utterance.onerror = (event) => {
                console.error('Error en la síntesis de voz:', event.error);
                statusText.textContent = "Error al reproducir el audio.";
                isPlaying = false;
                updateButtonState();
            };
            
            speechSynthesis.speak(utterance);
        }
        
        function stopSpeaking() {
            speechSynthesis.cancel();
            isPlaying = false;
            updateButtonState();
        }

        function updateButtonState() {
            if (isPlaying) {
                playIcon.classList.add('hidden');
                stopIcon.classList.remove('hidden');
                buttonText.textContent = "Detener";
                playButton.classList.remove('bg-blue-600', 'hover:bg-blue-700');
                playButton.classList.add('bg-red-600', 'hover:bg-red-700');
            } else {
                playIcon.classList.remove('hidden');
                stopIcon.classList.add('hidden');
                buttonText.textContent = "Reproducir Audio";
                playButton.classList.remove('bg-red-600', 'hover:bg-red-700');
                playButton.classList.add('bg-blue-600', 'hover:bg-blue-700');
            }
        }

        playButton.addEventListener('click', () => {
            if (isPlaying) {
                stopSpeaking();
            } else {
                const textToSpeak = scriptTextarea.value;
                if (textToSpeak.trim()) {
                    speak(textToSpeak);
                } else {
                    statusText.textContent = "El área de texto está vacía.";
                }
            }
        });

        if ('speechSynthesis' in window) {
            speechSynthesis.onvoiceschanged = loadAndSetVoice;
        }

        window.onload = loadAndSetVoice;
    </script>

</body>
</html>
