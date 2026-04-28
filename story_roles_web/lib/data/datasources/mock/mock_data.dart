// Mock data representing a real publishing company (Helion) setup.
//
// Roles:  0 = admin, 1 = owner, 2 = member
// Track statuses:  0 = pending, 1 = completed

import 'package:story_roles_web/data/models/chapter_response_dto.dart';
import 'package:story_roles_web/data/models/company_response_dto.dart';
import 'package:story_roles_web/data/models/project_response_dto.dart';
import 'package:story_roles_web/data/models/track_response_dto.dart';
import 'package:story_roles_web/data/models/attributes_response_dto.dart';
import 'package:story_roles_web/data/models/user_response_dto.dart';
import 'package:story_roles_web/domain/entities/script_word.dart';

abstract final class MockData {
  // ── Company ────────────────────────────────────────────────────────────────

  static final company = CompanyResponseDto(
    id: 1,
    name: 'Helion S.A.',
    allowedUsers: 10,
    active: true,
    createdAt: DateTime(2022, 1, 15),
  );

  // ── Users ──────────────────────────────────────────────────────────────────
  // role 1 = owner, role 2 = member

  static final users = <UserResponseDto>[
    UserResponseDto(
      id: 1,
      role: 1,
      companyId: 1,
      username: 'anna.kowalska',
      email: 'anna.kowalska@helion.pl',
      active: true,
      createdAt: DateTime(2022, 1, 15),
    ),
    UserResponseDto(
      id: 2,
      role: 2,
      companyId: 1,
      username: 'marek.nowak',
      email: 'marek.nowak@helion.pl',
      active: true,
      createdAt: DateTime(2022, 3, 10),
    ),
    UserResponseDto(
      id: 3,
      role: 2,
      companyId: 1,
      username: 'katarzyna.wiśniewska',
      email: 'k.wisniewska@helion.pl',
      active: true,
      createdAt: DateTime(2022, 5, 20),
    ),
    UserResponseDto(
      id: 4,
      role: 2,
      companyId: 1,
      username: 'piotr.zielinski',
      email: 'p.zielinski@helion.pl',
      active: false,
      createdAt: DateTime(2023, 2, 1),
    ),
  ];

  // ── Projects ───────────────────────────────────────────────────────────────

  static final projects = <ProjectResponseDto>[
    ProjectResponseDto(
      id: 1,
      companyId: 1,
      userId: 1,
      name: 'Wiedźmin – Ostatnie Życzenie',
      createdAt: DateTime(2024, 1, 10),
    ),
    ProjectResponseDto(
      id: 2,
      companyId: 1,
      userId: 2,
      name: 'Solaris – Stanisław Lem',
      createdAt: DateTime(2024, 3, 5),
    ),
    ProjectResponseDto(
      id: 3,
      companyId: 1,
      userId: 1,
      name: 'Pan Tadeusz – Audiobook',
      createdAt: DateTime(2024, 6, 18),
    ),
    ProjectResponseDto(
      id: 4,
      companyId: 1,
      userId: 3,
      name: 'Zbrodnia i Kara – Dostojewski',
      createdAt: DateTime(2025, 1, 22),
    ),
    ProjectResponseDto(
      id: 5,
      companyId: 1,
      userId: 2,
      name: 'Sherlock Holmes – A Study in Scarlet',
      createdAt: DateTime(2026, 1, 10),
    ),
  ];

  // ── Chapters ───────────────────────────────────────────────────────────────

  static final chapters = <ChapterResponseDto>[
    // Project 1 – Wiedźmin
    ChapterResponseDto(
      id: 1,
      projectId: 1,
      name: 'Rozdział 1 – Ziarno Prawdy',
      content:
          'Geralt jechał przez las skąpany w wieczornej mgle. Drzewa po obu stronach drogi stały nieruchomo, '
          'jakby zasłuchane we własne milczenie. Wiedźmin nie zwracał na nie uwagi – zbyt wiele razy '
          'przemierzał podobne drogi, by jeszcze odczuwać niepokój na ich widok.',
      createdAt: DateTime(2024, 1, 12),
    ),
    ChapterResponseDto(
      id: 2,
      projectId: 1,
      name: 'Rozdział 2 – Droga bez Powrotu',
      content:
          'Miasteczko Murivel wyglądało jak każde inne w tej części kontynentu – szare, biedne i przestraszone. '
          'Geralt wjechał do niego o zmierzchu, odprowadzany wzrokiem mieszkańców, którzy nie odważyli się '
          'głośno komentować przybycia wiedźmina.',
      createdAt: DateTime(2024, 1, 20),
    ),
    ChapterResponseDto(
      id: 3,
      projectId: 1,
      name: 'Rozdział 3 – Ostatnie Życzenie',
      content: null, // content not yet uploaded
      createdAt: DateTime(2024, 2, 3),
    ),

    // Project 2 – Solaris
    ChapterResponseDto(
      id: 4,
      projectId: 2,
      name: 'Rozdział 1 – Przybycie',
      content:
          'Kelvin wylądował na stacji o świcie. Przez okno wahadłowca widział ocean – nieruchomy, '
          'purpurowy, nieprzenikniony. Nie spodziewał się, że widok ten będzie prześladował go przez '
          'wszystkie lata pobytu na Solaris.',
      createdAt: DateTime(2024, 3, 7),
    ),
    ChapterResponseDto(
      id: 5,
      projectId: 2,
      name: 'Rozdział 2 – Ocean',
      content:
          'Przez kolejne dni Kelvin próbował zrozumieć raporty swoich poprzedników. Każdy z nich opisywał '
          'ocean inaczej – jako byt żywy, jako maszynę, jako lustro duszy. Żaden opis nie wydawał się '
          'kompletny.',
      createdAt: DateTime(2024, 3, 15),
    ),

    // Project 3 – Pan Tadeusz
    ChapterResponseDto(
      id: 6,
      projectId: 3,
      name: 'Księga I – Gospodarstwo',
      content:
          'Litwo! Ojczyzno moja! ty jesteś jak zdrowie; Ile cię trzeba cenić, ten tylko się dowie, '
          'Kto cię stracił. Dziś piękność twą w całej ozdobie Widzę i opisuję, bo tęsknię po tobie.',
      createdAt: DateTime(2024, 6, 20),
    ),
    ChapterResponseDto(
      id: 7,
      projectId: 3,
      name: 'Księga II – Zamek',
      content: null,
      createdAt: DateTime(2024, 7, 1),
    ),

    // Project 5 – Sherlock Holmes
    ChapterResponseDto(
      id: 9,
      projectId: 5,
      name: 'Chapter 1 – Mr. Sherlock Holmes',
      content:
          'Sherlock Holmes took his bottle from the corner of the mantel-piece and his hypodermic syringe '
          'from its neat morocco case. With his long, white, nervous fingers he adjusted the delicate needle, '
          'and rolled back his left shirt-cuff. For some little time his eyes rested thoughtfully upon the '
          'sinewy forearm and wrist, all dotted and scarred with innumerable puncture-marks. Finally he thrust '
          'the sharp point home, pressed down the tiny piston, and sank back into the velvet-lined arm-chair '
          'with a long sigh of satisfaction. Three times a day for many months I had witnessed this performance, '
          'but custom had not reconciled my mind to it. On the contrary, from day to day I had become more '
          'irritable at the sight, and my conscience swelled nightly within me at the thought that I had lacked '
          'the courage to protest. Again and again I had registered a vow that I should deliver my soul upon '
          'the subject, but there was that in the cool, nonchalant air of my companion which made him the last '
          'man with whom one would care to take anything approaching to a liberty. His great powers, his '
          'masterly manner, and the experience which I had had of his many extraordinary qualities, all made '
          'me diffident and backward in crossing him.',
      createdAt: DateTime(2026, 1, 12),
    ),

    // Project 4 – Zbrodnia i Kara
    ChapterResponseDto(
      id: 8,
      projectId: 4,
      name: 'Część I – Rozdział 1',
      content:
          'W gorący lipcowy wieczór, tuż przed zachodem słońca, młody człowiek wyszedł ze swej kamorki, '
          'którą wynajmował od lokatorów w zaułku S., na ulicę i powoli, jakby wahając się, skierował '
          'się ku mostowi K.',
      createdAt: DateTime(2025, 1, 25),
    ),
  ];

  // ── Tracks ─────────────────────────────────────────────────────────────────

  static final tracks = <TrackResponseDto>[
    // Chapter 1 – Wiedźmin: Ziarno Prawdy
    TrackResponseDto(
      id: 1,
      chapterId: 1,
      attributesResponseDto: AttributesResponseDto(
        title: 'Geralt jedzie przez las – lektor Andrzej',
        imageUrl: null,
        createdAt: DateTime(2024, 1, 13),
        status: 'completed',
      ),
    ),
    TrackResponseDto(
      id: 2,
      chapterId: 1,
      attributesResponseDto: AttributesResponseDto(
        title: 'Geralt jedzie przez las – lektor Maria',
        imageUrl: null,
        createdAt: DateTime(2024, 1, 13),
        status: 'completed',
      ),
    ),
    TrackResponseDto(
      id: 3,
      chapterId: 1,
      attributesResponseDto: AttributesResponseDto(
        title: 'Geralt jedzie przez las – lektor Tomasz',
        imageUrl: null,
        createdAt: DateTime(2024, 1, 14),
        status: 'pending',
      ),
    ),

    // Chapter 4 – Solaris: Przybycie
    TrackResponseDto(
      id: 4,
      chapterId: 4,
      attributesResponseDto: AttributesResponseDto(
        title: 'Kelvin ląduje na stacji – lektor Andrzej',
        imageUrl: null,
        createdAt: DateTime(2024, 3, 8),
        status: 'completed',
      ),
    ),
    TrackResponseDto(
      id: 5,
      chapterId: 4,
      attributesResponseDto: AttributesResponseDto(
        title: 'Kelvin ląduje na stacji – lektor Maria',
        imageUrl: null,
        createdAt: DateTime(2024, 3, 8),
        status: 'pending',
      ),
    ),

    // Chapter 9 – Sherlock Holmes: Chapter 1
    TrackResponseDto(
      id: 7,
      chapterId: 9,
      attributesResponseDto: AttributesResponseDto(
        title: 'Chapter 1 – Mr. Sherlock Holmes – Marie',
        imageUrl: null,
        createdAt: DateTime(2026, 1, 13),
        status: 'completed',
      ),
    ),

    // Chapter 6 – Pan Tadeusz: Księga I
    TrackResponseDto(
      id: 6,
      chapterId: 6,
      attributesResponseDto: AttributesResponseDto(
        title: 'Invokacja – lektor Krzysztof',
        imageUrl: null,
        createdAt: DateTime(2024, 6, 21),
        status: 'completed',
      ),
    ),
  ];

  // ── Scripts ────────────────────────────────────────────────────────────────
  // Keyed by track id. Only tracks with completed alignment have entries.

  static final scriptWords = <int, List<ScriptWord>>{
    // Track 7 – Sherlock Holmes Chapter 1, Marie
    7: [
      ScriptWord(word: 'Sherlock', startMs: 540, endMs: 880),
      ScriptWord(word: 'Holmes', startMs: 940, endMs: 1240),
      ScriptWord(word: 'took', startMs: 1300, endMs: 1480),
      ScriptWord(word: 'his', startMs: 1520, endMs: 1660),
      ScriptWord(word: 'bottle', startMs: 1700, endMs: 2020),
      ScriptWord(word: 'from', startMs: 2080, endMs: 2260),
      ScriptWord(word: 'the', startMs: 2300, endMs: 2400),
      ScriptWord(word: 'corner', startMs: 2440, endMs: 2780),
      ScriptWord(word: 'of', startMs: 2820, endMs: 2920),
      ScriptWord(word: 'the', startMs: 2960, endMs: 3060),
      ScriptWord(word: 'mantel-piece', startMs: 3100, endMs: 3680),
      ScriptWord(word: 'and', startMs: 3720, endMs: 3860),
      ScriptWord(word: 'his', startMs: 3900, endMs: 4020),
      ScriptWord(word: 'hypodermic', startMs: 4060, endMs: 4620),
      ScriptWord(word: 'syringe', startMs: 4680, endMs: 5040),
      ScriptWord(word: 'from', startMs: 5100, endMs: 5280),
      ScriptWord(word: 'its', startMs: 5320, endMs: 5440),
      ScriptWord(word: 'neat', startMs: 5480, endMs: 5700),
      ScriptWord(word: 'morocco', startMs: 5760, endMs: 6120),
      ScriptWord(word: 'case.', startMs: 6180, endMs: 6520),
      ScriptWord(word: 'With', startMs: 6800, endMs: 6980),
      ScriptWord(word: 'his', startMs: 7020, endMs: 7140),
      ScriptWord(word: 'long,', startMs: 7180, endMs: 7420),
      ScriptWord(word: 'white,', startMs: 7480, endMs: 7720),
      ScriptWord(word: 'nervous', startMs: 7780, endMs: 8160),
      ScriptWord(word: 'fingers', startMs: 8220, endMs: 8580),
      ScriptWord(word: 'he', startMs: 8640, endMs: 8740),
      ScriptWord(word: 'adjusted', startMs: 8780, endMs: 9220),
      ScriptWord(word: 'the', startMs: 9280, endMs: 9380),
      ScriptWord(word: 'delicate', startMs: 9420, endMs: 9860),
      ScriptWord(word: 'needle,', startMs: 9920, endMs: 10280),
      ScriptWord(word: 'and', startMs: 10540, endMs: 10680),
      ScriptWord(word: 'rolled', startMs: 10720, endMs: 11020),
      ScriptWord(word: 'back', startMs: 11060, endMs: 11260),
      ScriptWord(word: 'his', startMs: 11300, endMs: 11420),
      ScriptWord(word: 'left', startMs: 11460, endMs: 11680),
      ScriptWord(word: 'shirt-cuff.', startMs: 11720, endMs: 12280),
      ScriptWord(word: 'For', startMs: 12700, endMs: 12860),
      ScriptWord(word: 'some', startMs: 12900, endMs: 13100),
      ScriptWord(word: 'little', startMs: 13140, endMs: 13380),
      ScriptWord(word: 'time', startMs: 13420, endMs: 13660),
      ScriptWord(word: 'his', startMs: 13700, endMs: 13820),
      ScriptWord(word: 'eyes', startMs: 13860, endMs: 14080),
      ScriptWord(word: 'rested', startMs: 14120, endMs: 14480),
      ScriptWord(word: 'thoughtfully', startMs: 14540, endMs: 15140),
      ScriptWord(word: 'upon', startMs: 15200, endMs: 15440),
      ScriptWord(word: 'the', startMs: 15480, endMs: 15580),
      ScriptWord(word: 'sinewy', startMs: 15620, endMs: 16000),
      ScriptWord(word: 'forearm', startMs: 16060, endMs: 16480),
      ScriptWord(word: 'and', startMs: 16520, endMs: 16640),
      ScriptWord(word: 'wrist,', startMs: 16680, endMs: 17000),
      ScriptWord(word: 'all', startMs: 17060, endMs: 17220),
      ScriptWord(word: 'dotted', startMs: 17260, endMs: 17600),
      ScriptWord(word: 'and', startMs: 17640, endMs: 17760),
      ScriptWord(word: 'scarred', startMs: 17800, endMs: 18180),
      ScriptWord(word: 'with', startMs: 18220, endMs: 18400),
      ScriptWord(word: 'innumerable', startMs: 18440, endMs: 19100),
      ScriptWord(word: 'puncture-marks.', startMs: 19160, endMs: 19900),
    ],
  };

  // ── Credentials ────────────────────────────────────────────────────────────
  // Used by mock auth to validate login without hitting a real backend.

  static const _credentials = <String, _MockCredentials>{
    'anna.kowalska@helion.pl': _MockCredentials(
      password: 'helion2024!',
      userId: 1,
      token: 'mock-token-owner-helion-001',
    ),
    'marek.nowak@helion.pl': _MockCredentials(
      password: 'haslo123',
      userId: 2,
      token: 'mock-token-member-helion-002',
    ),
    'k.wisniewska@helion.pl': _MockCredentials(
      password: 'katarzyna!',
      userId: 3,
      token: 'mock-token-member-helion-003',
    ),
  };

  /// Returns a token when [email] + [password] match, otherwise null.
  static String? authenticate(String email, String password) {
    final cred = _credentials[email];
    if (cred == null || cred.password != password) return null;
    return cred.token;
  }

  /// Returns the userId for a given [token], or null if not found.
  static int? userIdForToken(String token) {
    for (final entry in _credentials.values) {
      if (entry.token == token) return entry.userId;
    }
    return null;
  }
}

class _MockCredentials {
  final String password;
  final int userId;
  final String token;

  const _MockCredentials({
    required this.password,
    required this.userId,
    required this.token,
  });
}
