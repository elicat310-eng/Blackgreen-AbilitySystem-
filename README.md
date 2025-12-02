# Roblox Ability System

Sistema de habilidades avanzado para Roblox: invisibilidad global y plataformas de salto.

## Estructura
- **Server/**: scripts que se ejecutan en el servidor.
- **Client/**: scripts locales que se ejecutan en los jugadores.
- **RemoteEvents**: `InvisibilityToggle` y `CreatePlatformRequest` en `ReplicatedStorage`.

## Uso
1. Colocar `Server_Abilities.lua` en `ServerScriptService`.
2. Colocar `Client_GUI.lua` en `StarterGui`.
3. Crear los RemoteEvents en `ReplicatedStorage` con los nombres exactos.
