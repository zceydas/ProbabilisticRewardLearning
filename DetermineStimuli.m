function [win,RT,endGame,StimName,earning]=DetermineStimuli(Exprun,deck,directory,TrialType,LeftSide,RightSide,Correct,window,xCenter, yCenter, baseRect, squareXpos, numSquares,rightkey, leftkey,endcode,simulation,fontcolor);% Clear the workspace and the screen
endGame=0;
% determine target and fixation cross durations below
fixFont=40;
firstFixDur=.3;
feedbackdur=2;
targetDur=2.5;
ITI=1+rand;

% Set different stimuli for Gain and Loss trials
if TrialType == 'Gain'
    StimName=['Stim' num2str(deck(Exprun)) num2str(1)];
else
    StimName=['Stim' num2str(deck(Exprun)) num2str(2)];
end
LeftTop=imread(fullfile(directory, 'PictureStimuli',[StimName LeftSide '.bmp']));
RightTop=imread(fullfile(directory, 'PictureStimuli',[StimName RightSide '.bmp']));


% Make our rectangle coordinates
allRects = nan(4, 2);
for i = 1:numSquares
    allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
end

% Pen width for the frames
penWidthPixels = 6;
ImageDim(1:2,:)=allRects(1:2,:)+6;
ImageDim(3:4,:)=allRects(3:4,:)-6;

% Draw fixation cross for ITI
Screen('TextSize',window, fixFont);
Screen('DrawText', window, sprintf( '%s', '+' ), xCenter, yCenter,fontcolor);
Screen('Flip',window); WaitSecs(ITI);

Screen('FrameRect', window, [0;0;0], allRects, penWidthPixels);
Screen('DrawText', window, sprintf( '%s', '+' ), xCenter, yCenter,fontcolor);

Screen(window,'PutImage',LeftTop,ImageDim(:,1));
Screen(window,'PutImage',RightTop,ImageDim(:,2));
Screen('Flip', window);
WaitSecs(.2);
response=0;
t0=GetSecs;
if simulation == 0
while GetSecs-t0<targetDur
    [keyIsDown,TimeStamp,keyCode] = KbCheck;
    if keyIsDown
        break;
    end 
end
else
keyCode=zeros(1,256);
keyCode(80)=1;
end
RT=GetSecs-t0;

Screen('DrawText', window, sprintf( '%s', '+' ), xCenter, yCenter,fontcolor);
if (keyCode(leftkey))
    Screen(window,'PutImage',LeftTop,ImageDim(:,1));
elseif (keyCode(rightkey))
    Screen(window,'PutImage',RightTop,ImageDim(:,2));
end
Screen('Flip', window); WaitSecs(firstFixDur);


if contains(LeftSide,Correct) == 1
    leftcorrect=1; rightcorrect=0;
else
    rightcorrect=1; leftcorrect=0;
end


if (~keyCode(endcode))
    if (keyCode(leftkey)) && leftcorrect == 1; win=1;  answer=1;  end
    if (keyCode(leftkey)) && leftcorrect == 0; win=0; answer=1;  end
    if (keyCode(rightkey)) && leftcorrect == 1; win=0;  answer=1;  end
    if (keyCode(rightkey)) && leftcorrect == 0; win=1;  answer=1;  end
    if (~keyCode(rightkey) && ~keyCode(leftkey))
        Screen('DrawText', window, sprintf( '%s', 'Only use left or right arrow keys.' ), xCenter-300, yCenter,fontcolor);
        Screen('Flip',window); WaitSecs(1); answer = 9; win=999; RT=999;
    end
else
    Screen('DrawText', window, sprintf( '%s', 'Press ESC to quit or press a key to continue.' ), xCenter-400, yCenter,fontcolor);
    Screen('Flip',window);
    endGame=1;
end

if win == 1
    if TrialType == 'Gain'
        feedback=imread(fullfile(directory,'PictureStimuli',['win_.bmp']));
        earning=10;
    elseif TrialType == 'Loss'
        feedback=imread(fullfile(directory,'PictureStimuli',['neutral_.bmp']));
        earning=0;
    end
elseif win == 0
    if TrialType == 'Gain'
        feedback=imread(fullfile(directory,'PictureStimuli',['neutral_.bmp']));
        earning=0;
    elseif  TrialType == 'Loss'
        feedback=imread(fullfile(directory,'PictureStimuli',['loss_.bmp']));
        earning=-10;
    end
end

FeedbackDims= CenterRectOnPointd([0 0 600 400], xCenter, yCenter);

if win < 999
    Screen(window,'PutImage',feedback,FeedbackDims);
    Screen('Flip', window);
    WaitSecs(feedbackdur);
end





