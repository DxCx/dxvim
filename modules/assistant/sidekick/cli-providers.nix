# Shared CLI provider definitions for sidekick.nvim
# Reference: https://github.com/folke/sidekick.nvim/blob/main/lua/sidekick/config.lua
{
  pkgs,
  lib,
}: let
  # Single source of truth for all providers
  # Each provider has both package info and tool definition
  providers = {
    aider = {
      package = pkgs.aider-chat or null;
      tool = {
        cmd = ["aider"];
        url = "https://github.com/Aider-AI/aider";
      };
    };
    claude = {
      package = null; # API-based, no CLI package needed
      tool = {
        cmd = ["claude"];
        url = "https://github.com/anthropics/claude-code";
      };
    };
    codex = {
      package = null; # API-based, no CLI package needed
      tool = {
        cmd = ["codex" "--search"];
        url = "https://github.com/openai/codex";
      };
    };
    copilot = {
      package = pkgs.gh-copilot or null;
      tool = {
        cmd = ["copilot" "--banner"];
        url = "https://github.com/github/copilot-cli";
      };
    };
    crush = {
      package = null; # Not commonly available in nixpkgs
      tool = {
        cmd = ["crush"];
        url = "https://github.com/charmbracelet/crush";
      };
    };
    cursor = {
      package = pkgs.cursor-cli or null;
      tool = {
        cmd = ["cursor-agent"];
        url = "https://cursor.com/cli";
      };
    };
    gemini = {
      package = null; # API-based, no CLI package needed
      tool = {
        cmd = ["gemini"];
        url = "https://github.com/google-gemini/gemini-cli";
      };
    };
    grok = {
      package = null; # Not commonly available in nixpkgs
      tool = {
        cmd = ["grok"];
        url = "https://github.com/superagent-ai/grok-cli";
      };
    };
    opencode = {
      package = null; # Not commonly available in nixpkgs
      tool = {
        cmd = ["opencode"];
        url = "https://github.com/sst/opencode";
      };
    };
    qwen = {
      package = null; # Not commonly available in nixpkgs
      tool = {
        cmd = ["qwen"];
        url = "https://github.com/QwenLM/qwen-code";
      };
    };
  };
in {
  inherit providers;
  # Automatically derive the list of available providers
  availableProviders = builtins.attrNames providers;
  # Helper to extract just packages (for backward compatibility)
  providerPackages = lib.mapAttrs (_: v: v.package) providers;
  # Helper to extract just tool definitions
  toolDefinitions = lib.mapAttrs (_: v: v.tool) providers;
}
