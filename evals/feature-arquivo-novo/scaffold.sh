#!/usr/bin/env bash
set -euo pipefail
cat > README.md <<"P"
Projeto Python sem dependências. Testes: python3 -m unittest
P
cat > test_base.py <<"P"
import unittest

class T(unittest.TestCase):
    def test_ok(self):
        self.assertTrue(True)
P
git init -q && git add -A && git -c user.name=eval -c user.email=eval@local commit -qm base
