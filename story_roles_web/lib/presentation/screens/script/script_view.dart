import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_roles_web/presentation/player/bloc/player_bloc.dart';
import 'package:story_roles_web/presentation/player/bloc/player_bloc_state.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';

// Hardcoded script for testing — replace with API call later.
// Source: script_20260320_141411_049157.json (Sherlock Holmes - The Sign of Four)
const _kTestScript = [
  {"word": "Sherlock", "start_ms": 540, "end_ms": 880},
  {"word": "Holmes", "start_ms": 940, "end_ms": 1240},
  {"word": "took", "start_ms": 1320, "end_ms": 1440},
  {"word": "his", "start_ms": 1480, "end_ms": 1560},
  {"word": "bottle", "start_ms": 1640, "end_ms": 1920},
  {"word": "from", "start_ms": 1960, "end_ms": 2060},
  {"word": "the", "start_ms": 2100, "end_ms": 2140},
  {"word": "corner", "start_ms": 2200, "end_ms": 2480},
  {"word": "of", "start_ms": 2540, "end_ms": 2580},
  {"word": "the", "start_ms": 2640, "end_ms": 2680},
  {"word": "mantel-piece,", "start_ms": 2740, "end_ms": 3400},
  {"word": "and", "start_ms": 3920, "end_ms": 3980},
  {"word": "his", "start_ms": 4020, "end_ms": 4100},
  {"word": "hypodermic", "start_ms": 4140, "end_ms": 4780},
  {"word": "syringe", "start_ms": 4860, "end_ms": 5280},
  {"word": "from", "start_ms": 5340, "end_ms": 5440},
  {"word": "its", "start_ms": 5500, "end_ms": 5580},
  {"word": "neat", "start_ms": 5680, "end_ms": 5800},
  {"word": "morocco", "start_ms": 5860, "end_ms": 6200},
  {"word": "case.", "start_ms": 6320, "end_ms": 6620},
  {"word": "With", "start_ms": 7260, "end_ms": 7340},
  {"word": "his", "start_ms": 7380, "end_ms": 7460},
  {"word": "long,", "start_ms": 7540, "end_ms": 7760},
  {"word": "white,", "start_ms": 7860, "end_ms": 8120},
  {"word": "nervous", "start_ms": 8220, "end_ms": 8480},
  {"word": "fingers", "start_ms": 8560, "end_ms": 8940},
  {"word": "he", "start_ms": 9000, "end_ms": 9020},
  {"word": "adjusted", "start_ms": 9100, "end_ms": 9500},
  {"word": "the", "start_ms": 9560, "end_ms": 9600},
  {"word": "delicate", "start_ms": 9660, "end_ms": 10000},
  {"word": "needle,", "start_ms": 10040, "end_ms": 10300},
  {"word": "then", "start_ms": 10960, "end_ms": 11060},
  {"word": "slowly", "start_ms": 11180, "end_ms": 11520},
  {"word": "rolled", "start_ms": 11640, "end_ms": 11860},
  {"word": "back", "start_ms": 11920, "end_ms": 12160},
  {"word": "his", "start_ms": 12240, "end_ms": 12340},
  {"word": "left", "start_ms": 12420, "end_ms": 12600},
  {"word": "shirt-cuff.", "start_ms": 12640, "end_ms": 13560},
  {"word": "For", "start_ms": 13988, "end_ms": 14088},
  {"word": "some", "start_ms": 14168, "end_ms": 14308},
  {"word": "little", "start_ms": 14368, "end_ms": 14548},
  {"word": "time", "start_ms": 14608, "end_ms": 14928},
  {"word": "his", "start_ms": 15008, "end_ms": 15128},
  {"word": "eyes", "start_ms": 15228, "end_ms": 15388},
  {"word": "rested", "start_ms": 15468, "end_ms": 15708},
  {"word": "thoughtfully", "start_ms": 15768, "end_ms": 16188},
  {"word": "upon", "start_ms": 16288, "end_ms": 16468},
  {"word": "the", "start_ms": 16568, "end_ms": 16608},
  {"word": "sinewy", "start_ms": 16648, "end_ms": 16928},
  {"word": "forearm", "start_ms": 17028, "end_ms": 17388},
  {"word": "and", "start_ms": 17428, "end_ms": 17488},
  {"word": "wrist,", "start_ms": 17528, "end_ms": 17828},
  {"word": "all", "start_ms": 18468, "end_ms": 18608},
  {"word": "dotted", "start_ms": 18708, "end_ms": 18988},
  {"word": "and", "start_ms": 19048, "end_ms": 19128},
  {"word": "scarred", "start_ms": 19188, "end_ms": 19488},
  {"word": "with", "start_ms": 19548, "end_ms": 19668},
  {"word": "innumerable", "start_ms": 19748, "end_ms": 20188},
  {"word": "puncture-marks.", "start_ms": 20248, "end_ms": 21488},
  {"word": "<gasp>", "start_ms": 22264, "end_ms": 23024},
  {"word": "Finally", "start_ms": 23064, "end_ms": 23484},
  {"word": "he", "start_ms": 23644, "end_ms": 23704},
  {"word": "thrust", "start_ms": 23844, "end_ms": 24224},
  {"word": "the", "start_ms": 24304, "end_ms": 24344},
  {"word": "sharp", "start_ms": 24444, "end_ms": 24644},
  {"word": "point", "start_ms": 24704, "end_ms": 24944},
  {"word": "home,", "start_ms": 25044, "end_ms": 25324},
  {"word": "pressed", "start_ms": 25844, "end_ms": 26144},
  {"word": "down", "start_ms": 26184, "end_ms": 26344},
  {"word": "the", "start_ms": 26404, "end_ms": 26464},
  {"word": "tiny", "start_ms": 26524, "end_ms": 26764},
  {"word": "piston,", "start_ms": 26864, "end_ms": 27284},
  {"word": "and", "start_ms": 28004, "end_ms": 28084},
  {"word": "sank", "start_ms": 28184, "end_ms": 28364},
  {"word": "back", "start_ms": 28444, "end_ms": 28624},
  {"word": "into", "start_ms": 28704, "end_ms": 28804},
  {"word": "the", "start_ms": 28864, "end_ms": 28924},
  {"word": "velvet-lined", "start_ms": 28984, "end_ms": 29564},
  {"word": "arm-chair", "start_ms": 29664, "end_ms": 30004},
  {"word": "with", "start_ms": 30064, "end_ms": 30164},
  {"word": "a", "start_ms": 30204, "end_ms": 30204},
  {"word": "long", "start_ms": 30304, "end_ms": 30584},
  {"word": "sigh", "start_ms": 30744, "end_ms": 31104},
  {"word": "of", "start_ms": 31144, "end_ms": 31184},
  {"word": "satisfaction", "start_ms": 31264, "end_ms": 31924},
  {"word": "<sigh>.", "start_ms": 31964, "end_ms": 34644},
  {"word": "Three", "start_ms": 35125, "end_ms": 35325},
  {"word": "times", "start_ms": 35405, "end_ms": 35665},
  {"word": "a", "start_ms": 35725, "end_ms": 35725},
  {"word": "day", "start_ms": 35785, "end_ms": 35945},
  {"word": "for", "start_ms": 36025, "end_ms": 36125},
  {"word": "many", "start_ms": 36185, "end_ms": 36345},
  {"word": "months", "start_ms": 36445, "end_ms": 36745},
  {"word": "I", "start_ms": 36905, "end_ms": 36905},
  {"word": "had", "start_ms": 36965, "end_ms": 37045},
  {"word": "witnessed", "start_ms": 37145, "end_ms": 37565},
  {"word": "this", "start_ms": 37625, "end_ms": 37745},
  {"word": "performance,", "start_ms": 37825, "end_ms": 38485},
  {"word": "but", "start_ms": 38985, "end_ms": 39085},
  {"word": "custom", "start_ms": 39165, "end_ms": 39685},
  {"word": "had", "start_ms": 39785, "end_ms": 39885},
  {"word": "not", "start_ms": 39965, "end_ms": 40125},
  {"word": "reconciled", "start_ms": 40205, "end_ms": 40725},
  {"word": "my", "start_ms": 40765, "end_ms": 40845},
  {"word": "mind", "start_ms": 40925, "end_ms": 41105},
  {"word": "to", "start_ms": 41185, "end_ms": 41225},
  {"word": "it.", "start_ms": 41325, "end_ms": 41965},
  {"word": "On", "start_ms": 42364, "end_ms": 42424},
  {"word": "the", "start_ms": 42464, "end_ms": 42504},
  {"word": "contrary,", "start_ms": 42584, "end_ms": 43084},
  {"word": "from", "start_ms": 43244, "end_ms": 43364},
  {"word": "day", "start_ms": 43464, "end_ms": 43584},
  {"word": "to", "start_ms": 43664, "end_ms": 43704},
  {"word": "day", "start_ms": 43784, "end_ms": 43944},
  {"word": "I", "start_ms": 44124, "end_ms": 44124},
  {"word": "had", "start_ms": 44224, "end_ms": 44304},
  {"word": "become", "start_ms": 44364, "end_ms": 44604},
  {"word": "more", "start_ms": 44664, "end_ms": 44784},
  {"word": "irritable", "start_ms": 44884, "end_ms": 45204},
  {"word": "at", "start_ms": 45264, "end_ms": 45304},
  {"word": "the", "start_ms": 45344, "end_ms": 45404},
  {"word": "sight,", "start_ms": 45484, "end_ms": 45744},
  {"word": "and", "start_ms": 46404, "end_ms": 46464},
  {"word": "my", "start_ms": 46524, "end_ms": 46604},
  {"word": "conscience", "start_ms": 46704, "end_ms": 47164},
  {"word": "swelled", "start_ms": 47244, "end_ms": 47604},
  {"word": "nightly", "start_ms": 47664, "end_ms": 47964},
  {"word": "within", "start_ms": 48044, "end_ms": 48264},
  {"word": "me", "start_ms": 48324, "end_ms": 48384},
  {"word": "at", "start_ms": 49744, "end_ms": 49784},
  {"word": "the", "start_ms": 49844, "end_ms": 49884},
  {"word": "thought", "start_ms": 49984, "end_ms": 50144},
  {"word": "that", "start_ms": 50184, "end_ms": 50264},
  {"word": "I", "start_ms": 50344, "end_ms": 50344},
  {"word": "had", "start_ms": 50384, "end_ms": 50464},
  {"word": "lacked", "start_ms": 50504, "end_ms": 50684},
  {"word": "the", "start_ms": 50724, "end_ms": 50764},
  {"word": "courage", "start_ms": 50824, "end_ms": 51104},
  {"word": "to", "start_ms": 51164, "end_ms": 51184},
  {"word": "protest.", "start_ms": 51244, "end_ms": 52124},
  {"word": "Again", "start_ms": 53099, "end_ms": 53319},
  {"word": "and", "start_ms": 53359, "end_ms": 53419},
  {"word": "again", "start_ms": 53459, "end_ms": 53759},
  {"word": "I", "start_ms": 53919, "end_ms": 53919},
  {"word": "had", "start_ms": 53979, "end_ms": 54059},
  {"word": "registered", "start_ms": 54119, "end_ms": 54499},
  {"word": "a", "start_ms": 54539, "end_ms": 54539},
  {"word": "vow", "start_ms": 54579, "end_ms": 54839},
  {"word": "that", "start_ms": 55779, "end_ms": 55999},
  {"word": "I", "start_ms": 56339, "end_ms": 56339},
  {"word": "should", "start_ms": 56379, "end_ms": 56519},
  {"word": "deliver", "start_ms": 56559, "end_ms": 56819},
  {"word": "my", "start_ms": 56899, "end_ms": 56999},
  {"word": "soul", "start_ms": 57119, "end_ms": 57319},
  {"word": "upon", "start_ms": 57379, "end_ms": 57559},
  {"word": "the", "start_ms": 57619, "end_ms": 57659},
  {"word": "subject.", "start_ms": 57739, "end_ms": 58199},
  {"word": "But", "start_ms": 59319, "end_ms": 59419},
  {"word": "there", "start_ms": 59479, "end_ms": 59619},
  {"word": "was", "start_ms": 59679, "end_ms": 59799},
  {"word": "something", "start_ms": 59959, "end_ms": 60499},
  {"word": "in", "start_ms": 60639, "end_ms": 60699},
  {"word": "the", "start_ms": 60759, "end_ms": 60819},
  {"word": "cool,", "start_ms": 60919, "end_ms": 61319},
  {"word": "nonchalant", "start_ms": 61459, "end_ms": 61899},
  {"word": "air", "start_ms": 61939, "end_ms": 62019},
  {"word": "of", "start_ms": 62099, "end_ms": 62159},
  {"word": "my", "start_ms": 62239, "end_ms": 62319},
  {"word": "companion", "start_ms": 62379, "end_ms": 62959},
  {"word": "which", "start_ms": 64019, "end_ms": 64179},
  {"word": "made", "start_ms": 64359, "end_ms": 64599},
  {"word": "him", "start_ms": 64639, "end_ms": 64739},
  {"word": "the", "start_ms": 64799, "end_ms": 64859},
  {"word": "last", "start_ms": 64939, "end_ms": 65279},
  {"word": "man", "start_ms": 65359, "end_ms": 65619},
  {"word": "with", "start_ms": 65739, "end_ms": 65859},
  {"word": "whom", "start_ms": 65919, "end_ms": 66119},
  {"word": "one", "start_ms": 66339, "end_ms": 66439},
  {"word": "would", "start_ms": 66499, "end_ms": 66619},
  {"word": "care", "start_ms": 66699, "end_ms": 66919},
  {"word": "to", "start_ms": 66959, "end_ms": 66979},
  {"word": "take", "start_ms": 67059, "end_ms": 67279},
  {"word": "anything", "start_ms": 67379, "end_ms": 67699},
  {"word": "approaching", "start_ms": 67759, "end_ms": 68219},
  {"word": "to", "start_ms": 68299, "end_ms": 68339},
  {"word": "a", "start_ms": 68439, "end_ms": 68439},
  {"word": "liberty.", "start_ms": 68519, "end_ms": 69279},
  {"word": "His", "start_ms": 69711, "end_ms": 69831},
  {"word": "great", "start_ms": 69931, "end_ms": 70171},
  {"word": "powers,", "start_ms": 70251, "end_ms": 70811},
  {"word": "his", "start_ms": 71191, "end_ms": 71271},
  {"word": "masterly", "start_ms": 71351, "end_ms": 71811},
  {"word": "manner,", "start_ms": 71911, "end_ms": 72231},
  {"word": "and", "start_ms": 72911, "end_ms": 73071},
  {"word": "the", "start_ms": 73191, "end_ms": 73251},
  {"word": "experience", "start_ms": 73311, "end_ms": 73971},
  {"word": "which", "start_ms": 74031, "end_ms": 74191},
  {"word": "I", "start_ms": 74311, "end_ms": 74311},
  {"word": "had", "start_ms": 74371, "end_ms": 74451},
  {"word": "had", "start_ms": 74511, "end_ms": 74691},
  {"word": "of", "start_ms": 74751, "end_ms": 74791},
  {"word": "his", "start_ms": 74831, "end_ms": 74931},
  {"word": "many", "start_ms": 75031, "end_ms": 75191},
  {"word": "extraordinary", "start_ms": 75331, "end_ms": 75851},
  {"word": "qualities", "start_ms": 75931, "end_ms": 76451},
  {"word": "all", "start_ms": 77331, "end_ms": 77431},
  {"word": "made", "start_ms": 77511, "end_ms": 77671},
  {"word": "me", "start_ms": 77711, "end_ms": 77731},
  {"word": "diffident", "start_ms": 77871, "end_ms": 78291},
  {"word": "and", "start_ms": 78391, "end_ms": 78471},
  {"word": "backward", "start_ms": 78511, "end_ms": 78911},
  {"word": "in", "start_ms": 78951, "end_ms": 78991},
  {"word": "crossing", "start_ms": 79071, "end_ms": 79431},
  {"word": "him.", "start_ms": 79491, "end_ms": 80031},
];

class ScriptView extends StatefulWidget {
  const ScriptView({super.key});

  @override
  State<ScriptView> createState() => _ScriptViewState();
}

class _ScriptViewState extends State<ScriptView> {
  final _scrollController = ScrollController();
  final _wordKeys = <int, GlobalKey>{};
  int _lastActiveIndex = -1;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int _activeWordIndex(int positionMs) {
    int active = -1;
    for (int i = 0; i < _kTestScript.length; i++) {
      final w = _kTestScript[i];
      if (positionMs >= (w['start_ms'] as int)) {
        active = i;
      } else {
        break;
      }
    }
    return active;
  }

  void _scrollToWord(int index) {
    final key = _wordKeys[index];
    if (key == null) return;
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      alignment: 0.4,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerBlocState>(
      builder: (context, state) {
        final posMs = state.playerState.position.inMilliseconds;
        final activeIndex = _activeWordIndex(posMs);

        if (activeIndex != _lastActiveIndex && activeIndex >= 0) {
          _lastActiveIndex = activeIndex;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToWord(activeIndex);
          });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 28, 32, 20),
              child: Text(
                'Script',
                style: TextStyle(
                  color: AppColors.onBackground,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 10,
                  children: [
                    for (int i = 0; i < _kTestScript.length; i++)
                      _WordChip(
                        key: _wordKeys.putIfAbsent(i, () => GlobalKey()),
                        word: _kTestScript[i]['word'] as String,
                        isActive: i == activeIndex,
                        isPast: i < activeIndex,
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WordChip extends StatelessWidget {
  final String word;
  final bool isActive;
  final bool isPast;

  const _WordChip({
    super.key,
    required this.word,
    required this.isActive,
    required this.isPast,
  });

  @override
  Widget build(BuildContext context) {
    final Color color;
    final FontWeight weight;
    final double fontSize;

    if (isActive) {
      color = AppColors.primary;
      weight = FontWeight.w700;
      fontSize = 22;
    } else if (isPast) {
      color = AppColors.onBackground.withValues(alpha: 0.4);
      weight = FontWeight.w400;
      fontSize = 20;
    } else {
      color = AppColors.onBackground.withValues(alpha: 0.85);
      weight = FontWeight.w400;
      fontSize = 20;
    }

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 120),
      style: TextStyle(color: color, fontWeight: weight, fontSize: fontSize),
      child: Text(word),
    );
  }
}
