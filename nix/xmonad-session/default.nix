{
  pkgs,
  ...
}: {
  home-manager.users.endrit = {
    xdg.configFile."xmonad" = {
      source = ../../xmonadrc;
      recursive = true;
    };
  };

  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      displayManager = {
        lightdm.enable = true;
        defaultSession = "none+xmonad";
      };
      windowManager = {
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = hpkgs:
            with hpkgs; [
              xmonad
              xmonad-contrib
              xmonad-extras
            ];
        };
      };
    };
    picom.enable = true;
  };

  programs = {
    slock.enable = true;
  };

  environment = {
    systemPackages =
      (with pkgs.haskellPackages; [
        xmobar-app
      ])
      ++ (with pkgs; [
        ranger # TUI file browser
        alacritty
        dmenu # Expected by xmonad
        gxmessage # Used by xmonad to show help
        pavucontrol # PulseAudio volume control UI
        brightnessctl # Brightness control CLI
        pamixer # PulseAudio volume mixer
      ]);
  };
}
