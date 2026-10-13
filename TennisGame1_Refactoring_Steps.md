# 🎾 TennisGame1 Refactoring Guide & Explanation

This document details the step-by-step refactoring process applied to [`TennisGame1`](file:///f:/Tennis-Refactoring-Kata/dart/lib/TennisGame1.dart) in Dart.

---

## 1. Code Smells & Issues in Legacy Code

The original implementation had several architectural and clean-code issues:
1. **Hardcoded Player Identification**: 
   In `wonPoint(String playerName)`, points were checked against `"player1"` hardcoded string (`playerName == "player1"`), ignoring the actual `_player1Name` variable initialized in constructor.
2. **Confusing & Inconsistent Naming**:
   Variables like `_m_score1` and `_m_score2` used Hungarian notation / inconsistent naming styles instead of standard idiomatic Dart.
3. **Complex Nested Control Flow & Magic Numbers**:
   `getScore()` combined three distinct tennis scoring phases (Tied game, Endgame/Advantage/Win, and Regular scoring) in a single convoluted method using switches, loops, and mutable state (`tempScore`, `minusResult`).
4. **Unnecessary Loops & String Concatenation**:
   Regular scoring used a 2-iteration loop (`for (int i=1; i<3; i++)`) with switch statements to build strings. In tennis, there are always exactly two players: Player 1 and Player 2.

---

## 2. Refactoring Steps (Step-by-Step)

### Step 1: Fix Domain Identification & Field Encapsulation
- Replaced `_m_score1` and `_m_score2` with descriptive names: `_player1Score` and `_player2Score`.
- Made `_player1Name` and `_player2Name` `final`.
- In `wonPoint`, checked against `_player1Name` instead of hardcoded `"player1"`.

```dart
@override
void wonPoint(String playerName) {
  if (playerName == _player1Name) {
    _player1Score++;
  } else {
    _player2Score++;
  }
}
```

### Step 2: Separate Scoring States (Separation of Concerns)
A tennis match scoring system has three distinct phases:
1. **Tied Game** (`_player1Score == _player2Score`)
2. **Endgame** (At least one player has $\ge 4$ points: Advantage or Win)
3. **Regular Running Score** (Standard score terms: Love, Fifteen, Thirty, Forty)

`getScore()` was decomposed to reflect these distinct rules cleanly:

```dart
@override
String getScore() {
  if (_isTied()) {
    return _formatTiedScore();
  }

  if (_hasEndgame()) {
    return _formatAdvantageOrWinScore();
  }

  return _formatRegularScore();
}
```

### Step 3: Replace Switch Statements with Lookup Constants
Mapped score numbers $(0 \to \text{"Love"}, 1 \to \text{"Fifteen"}, 2 \to \text{"Thirty"}, 3 \to \text{"Forty"})$ to a `const List<String>` lookup table:

```dart
static const List<String> _scoreTerms = [
  "Love",
  "Fifteen",
  "Thirty",
  "Forty",
];
```

### Step 4: Handle Tied Scores Cleanly
When scores are equal:
- Below 3 points: `"${_scoreTerms[_player1Score]}-All"` (e.g., "Love-All", "Fifteen-All", "Thirty-All")
- 3 points or more: `"Deuce"`

```dart
String _formatTiedScore() {
  if (_player1Score < 3) {
    return "${_scoreTerms[_player1Score]}-All";
  }
  return "Deuce";
}
```

### Step 5: Handle Advantage and Win (Endgame)
When $\ge 4$ points have been reached by either player:
- Determine who is in the lead:
  ```dart
  final scoreDifference = _player1Score - _player2Score;
  final leadingPlayer = scoreDifference > 0 ? _player1Name : _player2Name;
  ```
- If difference is 1 (absolute value): `"Advantage $leadingPlayer"`
- If difference is 2 or more: `"Win for $leadingPlayer"`

```dart
String _formatAdvantageOrWinScore() {
  final scoreDifference = _player1Score - _player2Score;
  final leadingPlayer = scoreDifference > 0 ? _player1Name : _player2Name;

  if (scoreDifference.abs() == 1) {
    return "Advantage $leadingPlayer";
  }
  return "Win for $leadingPlayer";
}
```

### Step 6: Handle Regular Scoring Without Loops
Eliminated the loop and switch cases completely with direct lookup:

```dart
String _formatRegularScore() {
  return "${_scoreTerms[_player1Score]}-${_scoreTerms[_player2Score]}";
}
```

---

## 3. Preserving Legacy Code

The original legacy class has been preserved as a block comment (`/* ... */`) directly inside [TennisGame1.dart](file:///f:/Tennis-Refactoring-Kata/dart/lib/TennisGame1.dart) for quick historical comparison and reference.

---

## 4. Test Verification
All 33 test scenarios in [tennis_test.dart](file:///f:/Tennis-Refactoring-Kata/dart/test/tennis_test.dart) (and 99 total kata assertions) passed successfully with 100% regression safety:
- Command: `dart test`
- Status: **All tests passed!**
