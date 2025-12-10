#!/bin/bash
nim c --cpu:arm -d:release -o:rpgmvp2png.arm rpgmvp2png.nim
nim c --cpu:arm64 -d:release -o:rpgmvp2png.arm rpgmvp2png.nim