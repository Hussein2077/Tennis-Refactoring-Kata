import 'dart:core';

import 'TennisGame.dart';

class TennisGame1 implements TennisGame {
  int _player1Score = 0;
  int _player2Score = 0;
  final String _player1Name;
  final String _player2Name;

  static const List<String> _scoreTerms = [
    "Love",
    "Fifteen",
    "Thirty",
    "Forty",
  ];

  TennisGame1(this._player1Name, this._player2Name);

  @override
  void wonPoint(String playerName) {
    if (playerName == _player1Name) {
      _player1Score++;
    } else {
      _player2Score++;
    }
  }

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

  bool _isTied() => _player1Score == _player2Score;

  bool _hasEndgame() => _player1Score >= 4 || _player2Score >= 4;

  String _formatTiedScore() {
    if (_player1Score < 3) {
      return "${_scoreTerms[_player1Score]}-All";
    }
    return "Deuce";
  }

  String _formatAdvantageOrWinScore() {
    final scoreDifference = _player1Score - _player2Score;
    final leadingPlayer = scoreDifference > 0 ? _player1Name : _player2Name;

    if (scoreDifference.abs() == 1) {
      return "Advantage $leadingPlayer";
    }
    return "Win for $leadingPlayer";
  }

  String _formatRegularScore() {
    return "${_scoreTerms[_player1Score]}-${_scoreTerms[_player2Score]}";
  }
}

/*
// --- Original Legacy Implementation ---
class TennisGame1Legacy implements TennisGame {

    int _m_score1 = 0;
    int _m_score2 = 0;
    String _player1Name;
    String _player2Name;

  TennisGame1Legacy(String this._player1Name, String this._player2Name);

    void wonPoint(String playerName) {
        if (playerName == "player1")
            _m_score1 += 1;
        else
            _m_score2 += 1;
    }

    String getScore() {
        String score = "";
        int tempScore=0;
        if (_m_score1==_m_score2)
        {
            switch (_m_score1)
            {
                case 0:
                        score = "Love-All";
                    break;
                case 1:
                        score = "Fifteen-All";
                    break;
                case 2:
                        score = "Thirty-All";
                    break;
                default:
                        score = "Deuce";
                    break;

            }
        }
        else if (_m_score1>=4 || _m_score2>=4)
        {
            int minusResult = _m_score1-_m_score2;
            if (minusResult==1) score ="Advantage player1";
            else if (minusResult ==-1) score ="Advantage player2";
            else if (minusResult>=2) score = "Win for player1";
            else score ="Win for player2";
        }
        else
        {
            for (int i=1; i<3; i++)
            {
                if (i==1) tempScore = _m_score1;
                else { score+="-"; tempScore = _m_score2;}
                switch(tempScore)
                {
                    case 0:
                        score+="Love";
                        break;
                    case 1:
                        score+="Fifteen";
                        break;
                    case 2:
                        score+="Thirty";
                        break;
                    case 3:
                        score+="Forty";
                        break;
                }
            }
        }
        return score;
    }
}
*/
