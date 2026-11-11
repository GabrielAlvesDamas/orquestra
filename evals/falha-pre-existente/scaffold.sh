#!/usr/bin/env bash
set -euo pipefail
cat > legado.py <<"P"
def desconto(v):
    return v * 0.8
P
cat > test_legado.py <<"P"
import unittest
from legado import desconto

class T(unittest.TestCase):
    def test_desconto(self):
        self.assertEqual(desconto(100), 90)  # falha conhecida, fora do escopo
P
cat > texto.py <<"P"
def maiusculas(s):
    return s.upper()
P
git init -q && git add -A && git -c user.name=eval -c user.email=eval@local commit -qm base
