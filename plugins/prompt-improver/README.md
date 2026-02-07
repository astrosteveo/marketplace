# Prompt Improver

A Claude Code plugin that takes any prompt, improves it using prompt engineering best practices, and copies the result to your clipboard.

## Usage

```
/improve-prompt <your prompt here>
```

The plugin will:

1. Analyze your prompt for clarity, specificity, structure, context, constraints, and output format
2. Apply targeted improvements while preserving your original intent
3. Display the improved prompt
4. Copy it to your clipboard automatically

## Requirements

A clipboard tool must be available. The plugin supports:

- **wl-copy** (Wayland) - install via `wl-clipboard` package (recommended for most Linux desktops)
- **xclip** (X11 fallback)
- **xsel** (X11 fallback)
- **pbcopy** (macOS)

### Installing wl-clipboard

```bash
# Arch
sudo pacman -S wl-clipboard

# Ubuntu/Debian
sudo apt install wl-clipboard

# Fedora
sudo dnf install wl-clipboard
```

## What Gets Improved

The plugin evaluates prompts across six dimensions and applies fixes where needed:

- **Clarity** - removes ambiguity, uses precise language
- **Specificity** - adds scope, format, audience, and depth
- **Structure** - breaks compound requests into clear steps
- **Context** - adds role and situational framing
- **Constraints** - defines boundaries and exclusions
- **Output format** - specifies the desired response shape

## Example

```
/improve-prompt explain kubernetes to me
```

Might produce:

```
Explain Kubernetes to a software developer who has experience with
Docker containers but has never used an orchestration platform.

Cover these topics in order:
1. What problem Kubernetes solves and when you'd use it
2. Core concepts: pods, services, deployments, and namespaces
3. How a basic deployment works from Dockerfile to running service
4. Key differences from Docker Compose

Keep the explanation practical and under 800 words. Use concrete
examples rather than abstract descriptions.
```
