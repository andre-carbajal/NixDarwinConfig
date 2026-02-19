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
        go-migrate
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
          "tailscale"
          "docker"
          "ytmdesktop-youtube-music"
        ];

        masApps = {
          "WhatsApp" = 310633997;
          "Xcode" = 497799835;
          "Word" = 462054704;
          "Excel" = 462058435;
          "PowerPoint" = 462062816;
          "OneDrive" = 823766827;
          "Teams" = 1113153706;
          "Bitwarden" = 1352778147;
          "FolderPreview" = 6698876601;
          "DaVinci Resolve" = 571213070;
          "Telegram" = 747648890;
          "Termius" = 1176074088;
          "The Unarchiver" = 425424353;
        };

        brews = [ "nvm" "gemini-cli" ];
      };

      # 3. Configuraciones de macOS (System Defaults)
      system.defaults = {
        dock = {
          autohide = true;
          show-recents = false;
        };
        finder = {
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
          FXPreferredViewStyle = "clmv";
        };
      };

      # 4. Configuracion del Sistema Nix
      system.primaryUser = "andrecarbajalvargas";
      nix.enable = false;
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
