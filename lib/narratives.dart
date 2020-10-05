class Story {
  List<String> chosenOptions = List();

  String completeStory() {
    var story = StringBuffer();

    for (int i = 0; i < chosenOptions.length; i++) {
      story.write(prompts[i].replaceAll('...', ''));
      story.write(chosenOptions[i].replaceAll('...', ''));
      story.write('\n');
    }

    return story.toString();
  }
}

const List<String> prompts = [
  'Once upon a time... ',
  'there was a... ',
  'who found... ',
  'belonging to... ',
];

const List<List<String>> options = [
  [
    'in another era... ',
    'deep underground... ',
    'under the sea... ',
    'in a galaxy far far away... ',
    'in a faraway land... ',
    'beyond the hills...',
  ],
  [
    'graceful bear... ',
    'misguided villain... ',
    'creative ant... ',
    'reclusive rabbit... ',
    'university student... ',
    'desperate dragon... ',
  ],
  [
    'a magic pencil... ',
    'a golden poodle... ',
    'a broken wand... ',
    'the seven dwarfs... ',
    'a pink hat... ',
    'the tesseract... ',
  ],
  [
    'Gandalf.',
    'Obiwan Kenobi.',
    'Voldermort.',
    'Tony Stark.',
    'Scooby Doo.',
    'Mickey Mouse.',
  ],
];
