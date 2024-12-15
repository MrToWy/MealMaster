import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../../common/widgets/base_scaffold.dart';
import '../../../common/widgets/info_dialog_button.dart';
import '../../../common/widgets/loading_button.dart';
import '../../../db/isar_factory.dart';
import '../../../db/storage_ingredient.dart';
import '../../../shared/open_ai/api_client.dart';
import '../../user_profile/data/user_repository.dart';
import 'widgets/detected_ingredient.dart';

class ValidateItemsScreen extends StatefulWidget {
  final List<StorageIngredient> ingredients;

  const ValidateItemsScreen({super.key, required this.ingredients});

  @override
  State<ValidateItemsScreen> createState() => _ValidateItemsScreenState();
}

class _ValidateItemsScreenState extends State<ValidateItemsScreen> {
  bool isRecording = false;
  bool isLoading = false;
  bool isLoadingVoice = false;
  final record = AudioRecorder();
  Stream<List<int>>? audioStream;

  Future<void> generateMealPlan() async {
    setState(() {
      isLoading = true;
    });
    await ApiClient.generateMealPlan(widget.ingredients,
        await UserRepository().getUser(), await IsarFactory().db);
    setState(() {
      isLoading = false;
    });

    if (!mounted) return;
    Navigator.of(context).popUntil((route) {
      return route.isFirst;
    });
  }

  Future<void> processVoiceInput(voiceString) async {
    setState(() {
      isLoadingVoice = true;
    });
    final updatedIngredients = await ApiClient.updateIngredientsFromText(
      widget.ingredients,
      voiceString,
    );
    if (updatedIngredients != null) {
      setState(() {
        widget.ingredients.clear();
        widget.ingredients.addAll(updatedIngredients);
      });
    }

    setState(() {
      isLoadingVoice = false;
    });
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> startRecording() async {
    if (!isRecording) {
      if (await record.hasPermission()) {
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/audio_message.m4a';

        await record.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: filePath,
        );
        setState(() {
          isRecording = true;
        });
      }
    } else {
      final path = await record.stop();
      setState(() {
        isRecording = false;
      });

      if (path != null) {
        String? result = await ApiClient.transcribeAudio(path);
        if (result != null) {
          if (!mounted) return;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  title: Text('Transkribierter Text'),
                  content: Text(result),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Abbrechen'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    isLoadingVoice
                        ? LoadingButton(text: "Vorräte bearbeiten...")
                        : FilledButton(
                            child: Text('Anwenden'),
                            onPressed: () async => {
                              setState(() {
                                isLoadingVoice = true;
                              }),
                              await processVoiceInput(result),
                              setState(() {
                                isLoadingVoice = false;
                              }),
                            },
                          ),
                  ],
                );
              });
            },
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BaseScaffold(
        title: 'Neuer Plan',
        hasBackButton: true,
        child: Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Text(
                    "Erkannte Zutaten",
                    style: textTheme.titleLarge,
                    textAlign: TextAlign.start,
                  ),
                  InfoDialogButton(
                    infoText:
                        "MealMaster hat die angezeigten Vorräte erkannt. Du kannst diese bearbeiten, oder unten weitere Vorräte hinzufügen. Wenn du unzufrieden bist, kannst du auch zurück gehen und neue Fotos hochladen.",
                    title: "Bestätige die erkannten Vorräte",
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: widget.ingredients.length,
                  itemBuilder: (context, index) {
                    final storageIngredient = widget.ingredients[index];
                    return DetectedIngredient(
                      name: storageIngredient.ingredient.value?.name ?? '',
                      count: storageIngredient.count ?? 0.0,
                      unit: storageIngredient.ingredient.value?.unit ?? '',
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    IconButton(
                        onPressed: () async => (isLoading || isLoadingVoice)
                            ? null
                            : await startRecording(),
                        iconSize: 40,
                        icon: Icon(
                          Icons.mic,
                          color: isRecording ? Colors.green : null,
                        )),
                    Text('Weitere Vorräte hinzufügen'),
                  ],
                ),
              ),
              SizedBox(height: 60),
              Center(
                child: isLoading
                    ? LoadingButton(text: "MealPlan wird generiert")
                    : FilledButton.icon(
                        icon: Icon(Icons.check),
                        onPressed: () async =>
                            isLoadingVoice ? null : await generateMealPlan(),
                        label: Text('MealPlan erstellen'),
                      ),
              ),
            ])));
  }
}
