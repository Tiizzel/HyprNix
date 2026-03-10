{pkgs}:
pkgs.writeShellScriptBin "list-keybinds" ''
  # check if rofi is already running
  if pidof rofi > /dev/null; then
    pkill rofi
  fi

  msg='☣️ NOTE ☣️: Clicking with Mouse or Pressing ENTER will have NO function'

  # Parse keybind entries from the Nix config and format for rofi display
  BIND_NIX="$HOME/HyprNix/modules/home/hyprland/binds.nix"
  if [[ -f "$BIND_NIX" ]]; then
    display_keybinds=$(
      ${pkgs.gawk}/bin/awk -f - "$BIND_NIX" <<'EOF'
        # Match any variable or keyword containing "bind" followed by =
        /([A-Za-z]*[Bb]ind[A-Za-z]*)[ ]*=/ { 
          in_block=1; 
          btype=$0; 
          sub(/[ ]*=.*/, "", btype); 
          gsub(/^[ ]+/, "", btype); 
        }

        in_block {
          # Check for end of array
          if (/\][ ]*;?/) {
            in_block = 0
            next
          }

          # Extract quoted string from line
          if (match($0, /"([^"]+)"/, arr)) {
            line = arr[1]

            # Split by comma to get parts
            n = split(line, parts, ",")
            
            # Extract and trim parts
            mods = parts[1]; sub(/^[[:space:]]*/, "", mods); sub(/[[:space:]]*$/, "", mods)
            key = parts[2];  sub(/^[[:space:]]*/, "", key);  sub(/[[:space:]]*$/, "", key)
            
            # For bindd/bindmd or variable binds, the third part is the description
            if (btype ~ /bindm?d/ || btype ~ /[A-Z].*Bind/) {
                desc = parts[3]; sub(/^[[:space:]]*/, "", desc); sub(/[[:space:]]*$/, "", desc)
            } else {
                # Fallback: if it is a standard bind, we don't have a desc field
                desc = parts[3]; sub(/^[[:space:]]*/, "", desc); sub(/[[:space:]]*$/, "", desc)
            }

            # Build display keybind
            display = key
            if (mods != "") display = mods " + " key
            gsub(/\$modifier/, "SUPER", display)
            gsub(/ +/, " ", display)

            # Output: "KEYBIND: Description"
            if (desc != "") {
              printf "%s: %s\n", display, desc
            }
          }
        }
EOF
    )
  else
    # Fallback: Show error message
    display_keybinds="Error: Keybinds file not found at $BIND_NIX"
  fi

  # use rofi to display the keybinds with the modified content
  echo "$display_keybinds" | rofi -dmenu -i -config ~/.config/rofi/config-long.rasi -mesg "$msg"

''
