{
  description = "A simple flake for an atomic system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nur.url = "github:nix-community/NUR";
    nixvim = {
      url = "github:Sly-Harvey/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-stable,
    ...
  } @ inputs: let
    # User configuration
    username = "tutuacs"; # WARNING REPLACE THIS WITH YOUR USERNAME IF MANUALLY INSTALLING
    terminal = "kitty"; # alacritty or kitty
    wallpaper = "marin.jpg"; # see modules/themes/wallpapers

    # System configuration
    hostname = "nixos"; # CHOOSE A HOSTNAME HERE (default is fine)
    locale = "pt_BR.UTF-8"; # REPLACE THIS WITH YOUR LOCALE
    timezone = "America/Sao_Paulo"; # REPLACE THIS WITH YOUR TIMEZONE
    kbdLayout = "us"; # REPLACE THIS WITH YOUR KEYBOARD LAYOUT

    system = "x86_64-linux"; # most users will be on 64 bit pcs (unless yours is ancient)
    lib = nixpkgs.lib;
    pkgs-stable = _final: _prev: {
      stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
        config.nvidia.acceptLicense = true;
      };
    };
    arguments = {
      inherit
        pkgs-stable
        username
        terminal
        wallpaper
        system
        locale
        timezone
        hostname
        kbdLayout
        ;
    };
  in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          specialArgs = (arguments // {inherit inputs;}) // inputs;
          modules = [./hosts/Default/configuration.nix];
        };
      };
    }
    // {
      # To use a template do: nix flake init -t $templates#TEMPLATE_NAME"
      templates = rec {
        default = ./dev-shells/empty;
        c-cpp = {
          path = ./dev-shells/c-cpp;
          description = "C/C++ development environment";
        };
        csharp = {
          path = ./dev-shells/csharp;
          description = "C# development environment";
        };
        go = {
          path = ./dev-shells/go;
          description = "Go (Golang) development environment";
        };
        java = {
          path = ./dev-shells/java;
          description = "Java development environment";
        };
        nix = {
          path = ./dev-shells/nix;
          description = "Nix development environment";
        };
        node = {
          path = ./dev-shells/node;
          description = "Node.js development environment";
        };
        php = {
          path = ./dev-shells/php;
          description = "PHP development environment";
        };
        protobuf = {
          path = ./dev-shells/protobuf;
          description = "Protobuf development environment";
        };
        python = {
          path = ./dev-shells/python;
          description = "Python development environment";
        };
        rust = {
          path = ./dev-shells/rust;
          description = "Rust development environment";
        };
        rust-toolchain = {
          path = ./dev-shells/rust-toolchain;
          description = "Rust development environment with Rust version defined by a rust-toolchain.toml file";
        };

        # Aliases
        c = c-cpp;
        cpp = c-cpp;
        rt = rust-toolchain;
      };
    };
}
