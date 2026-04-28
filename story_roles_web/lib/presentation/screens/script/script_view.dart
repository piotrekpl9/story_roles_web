import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_roles_web/domain/entities/script_word.dart';
import 'package:story_roles_web/presentation/player/bloc/player_bloc.dart';
import 'package:story_roles_web/presentation/player/bloc/player_bloc_state.dart';
import 'package:story_roles_web/presentation/screens/script/widgets/empty_script_placeholder.dart';
import 'package:story_roles_web/presentation/screens/script/widgets/word_chip.dart';
import 'package:story_roles_web/presentation/utils/app_config/app_colors.dart';

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

  int _activeWordIndex(List<ScriptWord> script, int positionMs) {
    int active = -1;
    for (int i = 0; i < script.length; i++) {
      if (positionMs >= script[i].startMs) {
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
        final script = state.script;
        final posMs = state.playerState.position.inMilliseconds;
        final activeIndex =
            script.isEmpty ? -1 : _activeWordIndex(script, posMs);

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
              child:
                  script.isEmpty
                      ? EmptyScriptPlaceholder(isLoading: state.isLoading)
                      : SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 10,
                          children: [
                            for (int i = 0; i < script.length; i++)
                              WordChip(
                                key: _wordKeys.putIfAbsent(
                                  i,
                                  () => GlobalKey(),
                                ),
                                word: script[i].word,
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
