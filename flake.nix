{
  description = "Configuracion Nix-Darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, darwin, ... }:
  let
    configuration = { pkgs, ... }: {
      
      # 1. Paquetes del Sistema (Binarios de Nix)
      environment.systemPackages = with pkgs; [
        # Web & Runtimes
        bun
        deno
        go
        golang-migrate
        uv
        
        # Herramientas CLI que ya usas
        neovim
        cmake
        ninja
        nmap
        fastfetch
        ffmpeg
        gh
        httpie
        fzf
        speedtest-cli
      ];

      # 2. Integracion con Homebrew (Para Apps Graficas y Casks)
      homebrew = {
        enable = true;
        onActivation.cleanup = "zap";
        
        casks = [
	  "warp"
	  "mos"
	  "tailscale"
	  "youtube-music" 
          "docker" 
        ];

        # Si prefieres mantener nvm y sdkman por ahora vía brew
        brews = [ "nvm" ];
      };

      # 3. Configuraciones de macOS (System Defaults)
      system.defaults = {
        dock = {
          autohide = true;
          show-recents = false; # Limpia un poco el Dock
        };
        finder = {
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
          FXPreferredViewStyle = "clmv"; # Vista de columnas, muy útil en ingeniería
        };
      };

      # 4. Configuracion del Sistema Nix
      services.nix-daemon.enable = true;
      nix.settings.experimental-features = "nix-command flakes";
      system.stateVersion = 4;

      # Define tu arquitectura (Cámbialo a "x86_64-darwin" si tu Mac es Intel)
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    darwinConfigurations."andrecarbajalvargas" = darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
