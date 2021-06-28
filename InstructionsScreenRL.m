function []=InstructionsScreenRL(window,fontcolor)

DrawFormattedText(window, sprintf('%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s', ...
    'Welcome to the REWARDS game.', ...
    'This game consists of three blocks.', ...
    'Each block takes 5 minutes to complete.', ...
    'Press a key to read the game rules.'), 'center', 'center',fontcolor,[100],[],[],[2]);
Screen('Flip',window); KbStrokeWait;

DrawFormattedText(window, sprintf('%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s', ...
    'On each trial, your task will be to find the most rewarding symbol.', ...
    '1) First you will see two symbols on the screen', ...
    '2) By pressing LEFT and RIGHT arrows, you choose the symbol on that side of the screen.', ...
    '3) Next, you will see how much you won or lost by choosing that symbol.'), 'center', 'center',fontcolor,[100],[],[],[2]);
Screen('Flip',window); KbStrokeWait;

DrawFormattedText(window, sprintf('%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s', ...
    'On some trials, a symbol will earn $10; on some trials, it will earn nothing,', ...
    'on some trials, another symbol will lose $10; on some trials, it will lose nothing. ', ...
    'The two symbols displayed on the same screen are not equal in terms of', ...
    'outcome: with one you have a better chance of getting something than the other.', ...
    'Your task is to find the symbols that maximize your reward.', ...
    'You can only learn which symbols are good or bad by trial and error.'), 'center', 'center',fontcolor,[100],[],[],[2]);
Screen('Flip',window); KbStrokeWait;

DrawFormattedText(window, sprintf('%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s', ...
    'Always make a response, using left and right arrow keys.,', ...
    'Try to make your decision as quickly as possible. ', ...
    'Do you have any questions?.'), 'center', 'center',fontcolor,[100],[],[],[2]);
Screen('Flip',window); KbStrokeWait;

DrawFormattedText(window, sprintf('%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s', ...
    'Now press a key to start the game.'), 'center', 'center',fontcolor, [100],[],[],[2]);
Screen('Flip',window); KbStrokeWait;