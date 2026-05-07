Przeczytaj CLAUDE.md i pliki w .agents/. Wykonaj poniższą pętlę:

## Pętla

### Krok 1: Architect
- Przeczytaj PHASE_PLAN.md, ARCHITECTURE.md, TASKS.md i stan repo.
- Zaplanuj JEDNO małe zadanie (max 2 pliki, max 3 AC).
- Zapisz do TASKS.md: ID, AC, i kompletny "Prompt for Gemma" (z kontekstem plików które Gemma musi znać).
- Jeśli nie ma już co planować (faza skończona) → powiedz "Faza zakończona." i STOP.

### Krok 2: Build
- Weź sekcję "Prompt for Gemma" z TASKS.md.
- Wywołaj: bash .agents/call_gemma.sh "Jesteś programistą. Odpowiadaj TYLKO kodem. Każdy plik otocz: FILE: ścieżka/plik.py potem ```lang kod ```. Żadnego gadania." "<prompt for gemma>"
- Zapisz pliki z outputu Gemmy na dysk.
- Jeśli Gemma zwróci błąd → STOP i powiedz co się stało.

### Krok 3: Test
- Uruchom testy (pytest / npm test / co pasuje).
- Sprawdź każde AC.
- Jeśli PASS → git add -A && git commit z tytułem zadania → wróć do Kroku 1.
- Jeśli FAIL (1. lub 2. raz) → dopisz issues do TASKS.md, wróć do Kroku 2.
- Jeśli FAIL (3. raz) → STOP i powiedz "3x FAIL, sprawdź TASKS.md".
- Jeśli BLOCKED → STOP i powiedz co wymaga decyzji.

## Zasady
- Bądź ZWIĘZŁY. Między krokami pisz max 1 linię statusu.
- NIE cytuj plików, NIE wyjaśniaj planów — po prostu działaj.
- NIE pisz kodu sam — kod pisze Gemma.
- Jedyny dłuższy output to edycja TASKS.md w kroku Architect.
