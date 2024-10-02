{
  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "kadza-tools";
      paths = [
        mariadb
        neovim
        ripgrep
        lazygit
        fd
        fzf
        python3
      ];
    };
  };
}
