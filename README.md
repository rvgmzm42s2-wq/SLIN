# SLIN

SLIN is a native Windows personal AI system designed to grow through local memory, observations, learning, procedures, conversation context, and outcomes.

## Current build

SLIN 0.9.0 runs locally on Windows and includes:
- Native Silin windowed chat interface
- Local generative AI model
- Persistent memory and recall
- Conversation state and beliefs
- Session context
- Reasoning and tone detection
- Learning/observation storage
- System diagnostics and health checks
- Sensor discovery
- Self-tests
- Logging and health reports
- Automatic local model setup
- Desktop shortcut creation

Normal conversation uses the local Silin model. SLIN does not switch to the old generic fallback conversation layer when the model is unavailable.

## Run on Windows

1. Download this repository as a ZIP.
2. Extract it.
3. Run `install.ps1`.
4. Open the new **Silin** desktop shortcut.

The first launch automatically prepares the local AI runtime and downloads the configured local model if it is not already installed. After setup, Silin runs as its own Windows window rather than a terminal chat.

No external AI API provider is required for inference.

Repository: https://github.com/rvgmzm42s2-wq/SLIN
