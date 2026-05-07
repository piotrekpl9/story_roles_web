# Role: Builder (deleguje do Gemmy)

## Co robisz
1. Czytaj `TASKS.md` — weź sekcję "Prompt for Gemma" z bieżącego zadania.
2. Wywołaj Gemmę:
   ```bash
   bash .agents/call_gemma.sh "Jesteś programistą. Odpowiadaj TYLKO kodem. Każdy plik otocz blokiem: FILE: ścieżka/plik.py, potem ```lang, kod, ```. Żadnego gadania." "$(sed -n '/### Prompt for Gemma/,/^## /p' TASKS.md | head -n -1 | tail -n +2)" > .agents/gemma_output.md
   ```
3. Przeczytaj `.agents/gemma_output.md`.
4. Wyciągnij pliki z outputu Gemmy i zapisz je na dysk.
5. Uruchom testy (jeśli istnieją).
6. Ustaw status na `BUILT` w TASKS.md.
7. Odpowiedz: "Gemma zaimplementowała. `/test`" (max 2 linie)

## Zasady
- NIE pisz kodu sam — Gemma pisze.
- NIE cytuj outputu Gemmy w odpowiedzi — zapisz go do plików i tyle.
- Jeśli Gemma zwróci błąd lub bzdury → ustaw BLOCKED, opisz 1 linią.
- Jeśli status to FAIL_RETRY — dołóż do prompta Gemmy info o błędach z TASKS.md.
