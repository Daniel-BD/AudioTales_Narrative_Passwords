import 'package:flutter/material.dart';

const primaryColor = Color(0xFFCF88CC);
const appBarColor = Colors.transparent;
const destructiveColor = Color(0xFFED4B40);
const inactiveColor = Color(0xFFC4C4C4);
const secondColor = Color(0xFF1B2432);
const indicatorColor = Color(0xFF0D324D);

const signInWelcomeText = 'Sign in to your account';
const createNewAccountText = 'Create account';
const startPasswordButtonText = 'Start Narrative Password';
const dontHaveAccountText = 'Don\'t have an account?';
const createAnAccountButtonText = 'Create an account';
const alreadyHaveAccountText = 'Already have an account?';
const signInButtonText = 'Sign in';
const continueToPasswordCreationButtonText = 'Continue to Password Creation';

const signInPasswordScreenTitle = 'Sign In';
const createPasswordScreenTitle = 'Create Password';

const signInPasswordHeadline = 'Tell your Story';
const createPasswordHeadline = 'Create your Story';

const reviewCreatedStoryHeadline = 'Your created story is:';
const isPasswordCorrectQuestionText = 'Do you want this as password?';
const confirmCreatedPasswordButtonText = 'Yes';
const regretCreatedPasswordButtonText = 'No, let me create another one';
const repeatPasswordToConfirm = 'Please repeat your story\nto confirm it as your password';
const tryAgainText = 'Oops! Try again.';
const triesLeftText = 'tries left.';

const createPasswordInstructionText =
    'You will now create your own narrative password! It is a simple process, really.\n\nFor each prompt you are presented, there will be a number of alternatives available to build on to the story. Choose an alternative to create YOUR story and to proceed to the next section.\n\nAt the end you can see your entire story, and this will be your narrative password to memorize!\n';
const youForgotPasswordText = 'Oh no!\nIt seems like you have forgotten your narrative password.';
const letsReviewPasswordAgainText = 'Let\'s review it again!';
const registrationCompleteText = 'Great!\nYour registration is now complete!';
const continueToAudioTalesButtonText = 'Continue to AudioTales';

const List<String> prompts = [
  'Once upon a time',
  'there lived',
  'who loved to',
  'during the',
];

const List<List<String>> narrativeOptions = [
  [
    'on a deserted island',
    'deep underground',
    'under the sea',
    'in a galaxy far far away',
    'in a faraway land',
    'in a bustling city',
  ],
  [
    'fallen angel',
    'a smelly troll',
    'creative ant',
    'reclusive rabbit',
    'three stray cats',
    'desperate dragon',
  ],
  [
    'go fishing',
    'throw rotten eggs',
    'wash clothes',
    'do gardening',
    'paint portraits',
    'get into fights',
  ],
  [
    'holidays.',
    'middle of the night.',
    'afternoon.',
    'weekends.',
    'summer.',
    'autumn season.',
  ],
];
