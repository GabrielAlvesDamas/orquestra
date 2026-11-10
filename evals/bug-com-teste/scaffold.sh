#!/usr/bin/env bash
set -euo pipefail
cat > calc.py <<"P"
def media(xs):
    return sum(xs) / len(xs)
P
cat > test_calc.py <<"P"
import unittest
from calc import media

class T(unittest.TestCase):
    def test_media(self):
        self.assertEqual(media([2, 4]), 3)

if __name__ == "__main__":
    unittest.main()
P
git init -q && git add -A && git -c user.name=eval -c user.email=eval@local commit -qm base
