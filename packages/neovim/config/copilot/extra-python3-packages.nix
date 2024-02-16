{ python311Packages, ... }:
with python311Packages; [
  # CopilotChat.nvim dependancies
  tiktoken
  prompt-toolkit
  python-dotenv
  requests
  pynvim
]
