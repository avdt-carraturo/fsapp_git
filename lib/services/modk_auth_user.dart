class MockAuthService {
  static final Map<String, Map<String, dynamic>> _users = {
  
    "passeggero@test.it": {
      "password": "123",
      "role": "passeggero",
      "biglietto": {
        "treno": "AV4030",
        "carrozza": "10",
        "validoDal": DateTime(2025, 2, 5, 8, 30).toIso8601String(),
        "validoAl": DateTime(2026, 2, 5, 18, 0).toIso8601String(),
      }
    },
	
    "antonio@test.it": {
    "password": "123",
    "role": "passeggero",
    "biglietto": [
      {
        "treno": "AV4030",
        "carrozza": "9",
        "validoDal": DateTime(2025, 2, 5, 8, 30).toIso8601String(),
        "validoAl": DateTime(2026, 2, 5, 18, 0).toIso8601String(),
      },
      {
        "treno": "REG2045",
        "carrozza": "3",
        "validoDal": DateTime(2025, 2, 5, 8, 30).toIso8601String(),
        "validoAl": DateTime(2026, 2, 5, 18, 0).toIso8601String(),
      }
    ]
    },
	
	"veronica@test.it": {
    "password": "123",
    "role": "passeggero",
    "biglietto": [
      {
        "treno": "RE7777",
        "carrozza": "5",
        "validoDal": DateTime(2025, 2, 5, 8, 30).toIso8601String(),
        "validoAl": DateTime(2026, 2, 5, 18, 0).toIso8601String(),
      },
      {
        "treno": "REG2045",
        "carrozza": "4",
        "validoDal": DateTime(2024, 2, 5, 8, 30).toIso8601String(),
        "validoAl": DateTime(2025, 1, 1, 18, 0).toIso8601String(),
      }
    ]
    },
	
	"freccia@test.it": {
    "password": "123",
    "role": "passeggero",
    "biglietto": [
      {
        "treno": "AV0001",
        "carrozza": "1",
        "validoDal": DateTime(2026, 2, 5, 8, 30).toIso8601String(),
        "validoAl": DateTime(2026, 2, 5, 18, 0).toIso8601String(),
      },
      {
        "treno": "AV7890",
        "carrozza": "11",
        "validoDal": DateTime(2025, 2, 5, 8, 30).toIso8601String(),
        "validoAl": DateTime(2026, 2, 5, 18, 0).toIso8601String(),
      }
    ]
    },
	
    "gestore@test.it": {
      "password": "123",
      "role": "gestore",
    },
	
    "viewer@test.it": {
      "password": "123",
      "role": "visualizzatore",
    },
	
  };

  static Map<String, dynamic>? currentUser;

  static bool login(String email, String password) {
    if (_users.containsKey(email) &&
        _users[email]!["password"] == password) {
      
      currentUser = _users[email];
      return true;
    }
    return false;
  }

  static void logout() {
    currentUser = null;
  }
}
