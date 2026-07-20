#!/usr/bin/env bash
# Switch PipeWire audio profile for the onboard Intel audio card (ThinkPad T14s Gen4)
#
# Available profiles:
#   speaker    - Internal speakers (default desktop use)
#   headphones - Mini jack output (switches card to headphone jack)
#   pro        - Pro Audio (exposes all raw ALSA outputs, mostly useful for debugging)
#
# Usage: ./audio-profile.sh [speaker|headphones|pro]

CARD="alsa_card.pci-0000_00_1f.3-platform-skl_hda_dsp_generic"

PROFILE_SPEAKER="HiFi (HDMI1, HDMI2, HDMI3, Mic1, Mic2, Speaker)"
PROFILE_HEADPHONES="HiFi (HDMI1, HDMI2, HDMI3, Headphones, Mic1, Mic2)"
PROFILE_PRO="pro-audio"

case "$1" in
  speaker)
    pactl set-card-profile "$CARD" "$PROFILE_SPEAKER"
    echo "Switched to: speakers"
    ;;
  headphones)
    pactl set-card-profile "$CARD" "$PROFILE_HEADPHONES"
    echo "Switched to: headphones (mini jack)"
    ;;
  pro)
    pactl set-card-profile "$CARD" "$PROFILE_PRO"
    echo "Switched to: pro-audio"
    echo "Note: pro-audio exposes raw ALSA outputs. In practice the mini jack"
    echo "      doesn't work reliably here — use 'headphones' profile instead."
    ;;
  *)
    echo "Usage: $0 [speaker|headphones|pro]"
    echo
    echo "Current profile:"
    pactl list cards | grep -A1 "Active Profile" | grep -v "Active Profile" | sed 's/^[[:space:]]*/  /'
    ;;
esac
