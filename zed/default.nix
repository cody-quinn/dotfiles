{
  pkgs,
  username,
  ...
}:

{
  home-manager.users.${username} = {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "java"
        "zig"
        "nix"
        "csharp"
        "fsharp"
      ];

      extraPackages = with pkgs; [
        fsautocomplete
        nixd
        nil
      ];

      userSettings = {
        # Vim mode RAHHHH
        vim_mode = true;

        # Setting font & theme
        theme = "One Light";
        ui_font_size = 16;
        buffer_font_size = 13;
        buffer_font_family = "JetBrains Mono";

        # Editor fit & feel
        relative_line_numbers = true;
        middle_click_paste = false;
        show_wrap_guides = true;

        tabs = {
          git_status = true;
          file_icons = true;
        };

        terminal = {
          dock = "right";
          shell.program = "zsh";
        };

        file_scan_exclusions = [
          "**/.git"
          "**/.zig-cache"
        ];

        inlay_hints = {
          enabled = false;
          toggle_on_modifiers_press.alt = true;
        };

        # Language support
        format_on_save = "off";
        tab_size = 2;

        languages."Plain Text" = {
          ensure_final_newline_on_save = false;
        };

        # Markup & Configuration Languages
        languages."Markdown" = {
          wrap_guides = [ 80 ];
          format_on_save = "on";
        };

        languages."Nix" = {
          wrap_guides = [ 80 ];
        };

        # Programming Languages
        languages."C" = {
          wrap_guides = [ 100 ];
        };

        languages."Java" = {
          wrap_guides = [ 100 ];
        };

        languages."Zig" = {
          wrap_guides = [ 100 ];
          tab_size = 4;
        };
      };

      userKeymaps = [
        {
          bindings = {
            "ctrl-q" = null;
          };
        }
        {
          context = "Editor";
          bindings = {
            "f3" = "editor::Format";
            "f4" = "editor::Rewrap";
          };
        }
        {
          context = "Editor && vim_mode == normal && vim_operator == none && !VimWaiting";
          bindings = {
            "ctrl-w w" = "pane::CloseActiveItem";
            "space r" = "task::Rerun";
            "space R" = "task::Spawn";
            "space s d" = "command_palette::Toggle";
            "space s f" = "file_finder::Toggle";
            "space s g" = "pane::DeploySearch";
          };
        }
        {
          context = "Terminal";
          bindings = {
            "ctrl-w w" = "pane::CloseActiveItem";
            "ctrl-w h" = "workspace::ActivatePaneLeft";
            "ctrl-w l" = "workspace::ActivatePaneRight";
            "ctrl-w k" = "workspace::ActivatePaneUp";
            "ctrl-w j" = "workspace::ActivatePaneDown";
            "ctrl-w ctrl-w" = [
              "terminal::SendKeystroke"
              "ctrl-w"
            ];
          };
        }
      ];
    };
  };
}
