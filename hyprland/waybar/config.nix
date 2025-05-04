{
  modulesLeft ? [ ],
  modulesCenter ? [ ],
  modulesRight ? [ ],
}:

''
  {
    "layer": "top",
    "position": "top",

    "modules-left": ${builtins.toJSON modulesLeft},
    "modules-center": ${builtins.toJSON modulesCenter},
    "modules-right": ${builtins.toJSON modulesRight},

    "custom/padding": {
      "format": " "
    },

    "custom/minehub": {
      "exec": "mcstatus play.minehub.live status | grep players | awk '{ print \"Players: \" $2 }'",
      "interval": 30
    },

    "hyprland/workspaces": {
      "on-click": "activate",
      "on-scroll-up": "hyprctl dispatch workspace e+1",
      "on-scroll-down": "hyprctl dispatch workspace e-1",
      "format": "{icon}",
      "format-icons": {
        "11": "1",
        "12": "2",
        "13": "3",
        "14": "4",
        "15": "5",
        "16": "6",
        "17": "7",
        "18": "8",
        "19": "9",
        "20": "10"
      },
      "persistent-workspaces": {
        "*": 10
      }
    },

    "hyprland/window": {
      "separate-outputs": true
    },

    "pulseaudio": {
      "format": "{icon} {volume:2}%",
      "format-bluetooth": "{icon} {volume}%",
      "format-muted": "MUTE",
      "format-icons": {
        "headphones": "",
        "default": ["", ""]
      },
      "scroll-step": 5,
      "on-click": "pamixer -t",
      "on-click-right": "pavucontrol"
    },
    "memory": {
      "interval": 5,
      "format": "Mem {}%"
    },
    "cpu": {
      "interval": 5,
      "format": "CPU {usage}%"
    },
    "battery": {
      "states": {
        "good": 95,
        "warning": 30,
        "critical": 15
      },
      "format": "{icon} {capacity}%",
      "format-icons": ["", "", "", "", ""]
    },
    "disk": {
      "interval": 5,
      "tooltip-format": "Disk {percentage_used}%",
      "format": "{specific_used} out of {specific_total} used ({percentage_used}%)",
      "unit": "GB",
      "path": "/"
    },
    "clock": {
      "interval": 1,
      "format": "{:%I:%M:%S %p}",
      "tooltip": true
    }
  }
''
