{ global, pkgs, ... }:

let
  hostname = "k6-nix";
in
{
  imports = [
    ../common
    ./hardware-configuration.nix
    ../../modules/gui/system.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = hostname;
    domain = "local.cwzhou.win"
    useDHCP = false;
    dhcpcd.enable = false;
    interfaces.enp6s0.ipv4.addresses = [{
        address = "192.168.199.19";
        prefixLength = 28;
      }];
    defaultGateway = "192.168.199.1";
    nameservers = [ "192.168.199.20" "192.168.199.8" ];
    networkmanager.enable = true;
  };

  location = {
    provider = "manual";
    latitude = -33.8718;
    longitude = 151.2494;
  };

  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # List services that you want to enable:
  services = {
    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # Power management
    upower.enable = true;

    dbus.enable = true;

    openvpn.servers = {
      homeVPN = {
        autoStart = false;
        config = "config /etc/openvpn/au_sydney.ovpn";
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      media-session.config.bluez-monitor.rules = [
        {
          # Matches all cards
          matches = [{ "device.name" = "~bluez_card.*"; }];
          actions = {
            "update-props" = {
              "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
              # mSBC is not expected to work on all headset + adapter combinations.
              "bluez5.msbc-support" = true;
            };
          };
        }
        {
          matches = [
            # Matches all sources
            { "node.name" = "~bluez_input.*"; }
            # Matches all outputs
            { "node.name" = "~bluez_output.*"; }
          ];
          actions = {
            "node.pause-on-idle" = false;
          };
        }
      ];
    };

    # X compositor
    picom = {
      enable = true;
      inactiveOpacity = 0.8;
      backend = "glx";
      shadow = true;
      shadowOpacity = 0.5;
      shadowOffsets = [ (-60) (-25) ];
      shadowExclude = [
        "class_g = 'xmobar'"
        "class_g = 'google-chrome-stable'"
      ];
      opacityRules = [
        "90:class_g = 'alacritty'"
      ];
      settings = {
        shadow = { radius = 5; };
        blur = {
          background = true;
          backgroundFrame = true;
          backgroundFixed = true;
          kern = "3x3box";
          strength = 10;
        };
      };
    };

    redshift = {
      enable = true;
      brightness = {
        day = "1";
        night = "1";
      };
      temperature = {
        day = 5500;
        night = 3700;
      };
    };

    thermald.enable = true;

    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "ctrl:swapcaps";
      xkbVariant = "intl";
      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          disableWhileTyping = true;
          naturalScrolling = true;
        };
      };
      desktopManager.xterm.enable = false;
      updateDbusEnvironment = true;
      serverFlagsSection = ''
        Option "BlankTime" "180"
        Option "StandbyTime" "45"
        Option "SuspendTime" "45"
        Option "OffTime" "180"
      '';
    };

    getty.helpLine = ''
      [0;34;40m ███    ██ ██ ██   ██  ██████  ███████ 
      [0;34;40m ████   ██ ██  ██ ██  ██    ██ ██      
      [0;34;40m ██ ██  ██ ██   ███   ██    ██ ███████ 
      [0;34;40m ██  ██ ██ ██  ██ ██  ██    ██      ██ 
      [0;34;40m ██   ████ ██ ██   ██  ██████  ███████ 
      [0;37;40m
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
