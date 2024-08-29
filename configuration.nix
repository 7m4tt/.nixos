{ config, pkgs, ... }:

{
    # User Account.
    users.users.matt = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" "openrazer" ];
        packages = with pkgs; [
            firefox
            kitty
        ];
    };

    # Localization.
    time.timeZone = "Asia/Taipei";
    i18n.defaultLocale = "en_US.UTF-8";
    
    # Bootloader.
    boot = {
        tmp.cleanOnBoot = true;
        loader = {
            timeout = 1;
            efi.canTouchEfiVariables = true;
            grub = {
                enable = true;
                efiSupport = true;
                device = "nodev";
            };
        };
    };

    # Display Manager.
    services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
    };

    # Window Manager.
    programs.hyprland.enable = true;

    # Network Manager.
    networking.networkmanager.enable = true;

    # Bluetooth and Audio.
    hardware.bluetooth.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        jack.enable = true;
        pulse.enable = true;
    };

    # Default Shell.
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
    
    # Openrazer Daemon.
    hardware.openrazer.enable = true;

    # Graphics Driver.
    nixpkgs.config.allowUnfree = true;
    services.xserver.videoDrivers = ["nvidia"];
    hardware = {
        nvidia = {
            package = config.boot.kernelPackages.nvidiaPackages.beta;
            open = false;
            modesetting.enable = true;
            powerManagement = {
                enable = true;
                finegrained = true;
            };
            prime = {
                offload = {
                    enable = true;
                    enableOffloadCmd = true;
                };
                nvidiaBusId = "PCI:1:0:0";
                amdgpuBusId = "PCI:101:0:0";
            };
        };
    };

    # Font Packages.
    fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk
    ];
    
    # System Packages.
    environment.systemPackages = with pkgs; [
        neovim
        git
        openrazer-daemon
    ];

    # Nix Settings.
    nix = {
        settings = {
            auto-optimise-store = true;
            allowed-users = [ "matt" ];
        };
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
        };
        extraOptions = ''
            experimental-features = nix-command flakes
            keep-outputs = true
            keep-derivations = true
        '';
    };

    # Environment Variables.
    environment = {
        sessionVariables.NIXOS_OZONE_WL = "1";
        variables = {
            NIXOS_CONFIG = "$HOME/.nixos/configuration.nix";
            NIXOS_CONFIG_DIR = "$HOME/.nixos/";
            EDITOR = "nvim";
        };

    };

    # State Version.
    system.stateVersion = "24.05";
}