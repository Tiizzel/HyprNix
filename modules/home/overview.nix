{
  pkgs,
  config,
  lib,
  matugenRawColors,
  ...
}: let
  overviewSource = ./overview;
  c = config.lib.stylix.colors;
  themedAppearance = pkgs.writeText "Appearance.qml" ''
    pragma Singleton
    pragma ComponentBehavior: Bound

    import QtQuick
    import Quickshell
    import "functions"

    Singleton {
      id: root
      property QtObject m3colors
      property QtObject animation
      property QtObject animationCurves
      property QtObject colors
      property QtObject rounding
      property QtObject font
      property QtObject sizes

      m3colors: QtObject {
          property bool darkmode: true
          property color m3primary: "#${c.base0D}"
          property color m3onPrimary: "#${c.base00}"
          property color m3primaryContainer: "#${c.base02}"
          property color m3onPrimaryContainer: "#${c.base05}"
          property color m3secondary: "#${c.base0E}"
          property color m3onSecondary: "#${c.base00}"
          property color m3secondaryContainer: "#${c.base01}"
          property color m3onSecondaryContainer: "#${c.base05}"
          property color m3background: "#${c.base00}"
          property color m3onBackground: "#${c.base05}"
          property color m3surface: "#${c.base00}"
          property color m3surfaceContainerLow: "#${c.base00}"
          property color m3surfaceContainer: "#${c.base01}"
          property color m3surfaceContainerHigh: "#${c.base01}"
          property color m3surfaceContainerHighest: "#${c.base02}"
          property color m3onSurface: "#${c.base05}"
          property color m3surfaceVariant: "#${c.base01}"
          property color m3onSurfaceVariant: "#${c.base04}"
          property color m3inverseSurface: "#${c.base05}"
          property color m3inverseOnSurface: "#${c.base00}"
          property color m3outline: "#${c.base03}"
          property color m3outlineVariant: "#${c.base03}"
          property color m3shadow: "#000000"
      }

      colors: QtObject {
          property color colSubtext: m3colors.m3outline
          property color colLayer0: m3colors.m3background
          property color colOnLayer0: m3colors.m3onBackground
          property color colLayer0Border: ColorUtils.mix(root.m3colors.m3outlineVariant, colLayer0, 0.4)
          property color colLayer1: m3colors.m3surfaceContainerLow
          property color colOnLayer1: m3colors.m3onSurfaceVariant
          property color colOnLayer1Inactive: ColorUtils.mix(colOnLayer1, colLayer1, 0.45)
          property color colLayer1Hover: ColorUtils.mix(colLayer1, colOnLayer1, 0.92)
          property color colLayer1Active: ColorUtils.mix(colLayer1, colOnLayer1, 0.85)
          property color colLayer2: m3colors.m3surfaceContainer
          property color colOnLayer2: m3colors.m3onSurface
          property color colLayer2Hover: ColorUtils.mix(colLayer2, colOnLayer2, 0.90)
          property color colLayer2Active: ColorUtils.mix(colLayer2, colOnLayer2, 0.80)
          property color colPrimary: m3colors.m3primary
          property color colOnPrimary: m3colors.m3onPrimary
          property color colSecondary: m3colors.m3secondary
          property color colSecondaryContainer: m3colors.m3secondaryContainer
          property color colOnSecondaryContainer: m3colors.m3onSecondaryContainer
          property color colTooltip: m3colors.m3inverseSurface
          property color colOnTooltip: m3colors.m3inverseOnSurface
          property color colShadow: ColorUtils.transparentize(m3colors.m3shadow, 0.7)
          property color colOutline: m3colors.m3outline
      }

      rounding: QtObject {
          property int unsharpen: 2
          property int verysmall: 8
          property int small: 12
          property int normal: 17
          property int large: 23
          property int full: 9999
          property int screenRounding: large
          property int windowRounding: 18
      }

      font: QtObject {
          property QtObject family: QtObject {
              property string main: "sans-serif"
              property string title: "sans-serif"
              property string expressive: "sans-serif"
          }
          property QtObject pixelSize: QtObject {
              property int smaller: 12
              property int small: 15
              property int normal: 16
              property int larger: 19
              property int huge: 22
          }
      }

      animationCurves: QtObject {
          readonly property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1.00, 1, 1]
          readonly property list<real> expressiveEffects: [0.34, 0.80, 0.34, 1.00, 1, 1]
          readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
          readonly property real expressiveDefaultSpatialDuration: 500
          readonly property real expressiveEffectsDuration: 200
      }

      animation: QtObject {
          property QtObject elementMove: QtObject {
              property int duration: animationCurves.expressiveDefaultSpatialDuration
              property int type: Easing.BezierSpline
              property list<real> bezierCurve: animationCurves.expressiveDefaultSpatial
              property Component numberAnimation: Component {
                  NumberAnimation {
                      duration: root.animation.elementMove.duration
                      easing.type: root.animation.elementMove.type
                      easing.bezierCurve: root.animation.elementMove.bezierCurve
                  }
              }
          }

          property QtObject elementMoveEnter: QtObject {
              property int duration: 400
              property int type: Easing.BezierSpline
              property list<real> bezierCurve: animationCurves.emphasizedDecel
              property Component numberAnimation: Component {
                  NumberAnimation {
                      duration: root.animation.elementMoveEnter.duration
                      easing.type: root.animation.elementMoveEnter.type
                      easing.bezierCurve: root.animation.elementMoveEnter.bezierCurve
                  }
              }
          }

          property QtObject elementMoveFast: QtObject {
              property int duration: animationCurves.expressiveEffectsDuration
              property int type: Easing.BezierSpline
              property list<real> bezierCurve: animationCurves.expressiveEffects
              property Component numberAnimation: Component {
                  NumberAnimation {
                      duration: root.animation.elementMoveFast.duration
                      easing.type: root.animation.elementMoveFast.type
                      easing.bezierCurve: root.animation.elementMoveFast.bezierCurve
                  }
              }
          }
      }

      sizes: QtObject {
          property real elevationMargin: 10
      }
    }
  '';
in {
  # Quickshell-overview is a Qt6 QML app for Hyprland workspace overview
  # It shows all workspaces with live window previews, drag-and-drop support
  # Toggled via: SUPER + TAB (bound in hyprland/binds.nix)
  # Started via exec-once in hyprland/exec-once.nix

  # Seed the Quickshell overview code into ~/.config/quickshell/overview
  # Copy (not symlink) so QML module resolution works and users can edit files
  home.activation.seedOverviewCode = lib.hm.dag.entryAfter ["writeBoundary"] ''
    set -eu
    DEST="$HOME/.config/quickshell/overview"
    SRC="${overviewSource}"

    if [ ! -d "$DEST" ]; then
      $DRY_RUN_CMD mkdir -p "$HOME/.config/quickshell"
      $DRY_RUN_CMD cp -R "$SRC" "$DEST"
      $DRY_RUN_CMD chmod -R u+rwX "$DEST"
    fi
    $DRY_RUN_CMD cp -f "${themedAppearance}" "$DEST/common/Appearance.qml"
    $DRY_RUN_CMD chmod u+rw "$DEST/common/Appearance.qml"
  '';
}
