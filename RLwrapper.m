%% Probabilistic Reward Learning Task
% Run this study by dragging/dropping RLwrapper function on the Matlab
% command window
% Enter subject ID and then indicate which session (test or re-test) it is

% Design specifics:
% Each run took around 5 minutes to complete and consisted of 56 trials. 
% Inter-trial intervals were randomly drawn from a normal distribution 
% centered around a mean of 1 s. for the training run. 

% On each run, two unique stimulus pairs, consisting of two symbols were presented. 
% The side of the screen each stimulus was presented was randomized across trials. 
% Participants learned to choose one of two stimuli based on the probabilistic 
% feedback presented on each trial. They were instructed to press a key corresponding 
% to the side of the stimulus pair they believed to be 'correct' that maximized their 
% total rewards and make their decisions as accurately and as quickly as possible. 
% Visual feedback was provided following each choice. Each stimulus pair stayed on 
% the screen for a maximum of 2,5 s., or until the participants made a response. 
% At the choice onset, participant's choice was highlighted by keeping the  
% the selected stimulus on the screen alone for 300 ms. 
% 
% There were two trial types: Gain and Loss trials. 
% Gain and Loss trials were presented in an interleaved order. 
% The order of Gain and Loss trials were randomized. 
% Two unique and distinct stimulus pairs were associated with each trial 
% type and each stimulus pair was unique to each run. For both trial types, 
% the correct stimulus led to positive feedback 75% of the time, while the 
% incorrect stimulus led to negative feedback on these trials. 
% During positive feedback in Gain trials,
% the image of a  €10 note bill was presented in the middle of the screen 
% under a "+ €10" text printed in color green. During the negative feedback 
% in Gain trials, the image of an empty grey rectangle was presented under 
% a "€0" text printed in color red. For the Loss trials, the positive feedback 
% corresponded to the same screen as the negative feedback during Gain trials, 
% signifying that participants did not incur a monetary loss. During negative
% feedback in Loss trials, the image of a €10 note bill was crossed out in
% color red under a "- €10" text printed in red. Feedback images stayed on 
% the screen for 1 s. for all feedback types. 


clear all
tic
st = dbstack;
namestr = st.name;
directory=fileparts(which([namestr, '.m']));
cd(directory)
addpath(directory) % set path to necessary files
endGame=0;
subjectId=input('What is subject ID?');
Session=input('What is study session? Test(1), ReTest(2): '); % this can be 1 or 2 (test and re-test)
simulation=input('Is this a simulation? Yes(1), No(0): '); % this can be 1 or 2 (test and re-test)
datafileName = ['ID_' num2str(subjectId) '_SessionNo' num2str(Session) '_Data Folder'];
if ~exist(datafileName, 'dir')
    mkdir(datafileName);
end
rng('default')
rng(subjectId)
cards=Shuffle([1:8]);
if Session == 1
    deck=cards(1:4);
elseif Session == 2
    deck=cards(5:8);
end

% prepare Psychtoolbox screen and keyboard
KbName('UnifyKeyNames')
KeyTemp=KbName('KeyNames');
rightkey = KbName('RightArrow');%'RightArrow';
leftkey = KbName('LeftArrow');%LeftArrow';
endcode =  KbName('ESCAPE'); %escape key - if you press Escape during the experiment, study will pause until next key stroke
Screen('Preference', 'SkipSyncTests', 1)
% Get the screen numbers
screens = Screen('Screens');
% Draw to the external screen if avaliable
screenNumber = max(screens);
% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
% Do a simply calculation to calculate the luminance value for grey. This
% will be half the luminace values for white
grey = white / 2;
% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);
% Make a base Rect of 200 by 200 pixels
baseRect = [0 0 200 200];
% Screen X positions of our three rectangle           s
squareXpos = [screenXpixels * 0.35 screenXpixels * 0.65];
numSquares = length(squareXpos);
fontcolor=grey;

% prepare practice and test condition order
ConditionList=readtable('ConditionList.xlsx');
% start the trial sequence
if simulation == 0
InstructionsScreenRL(window,fontcolor);
end
AllResults=[];

for Exprun=1:3
    
    ConditionList.Trial=shuffle(ConditionList.Trial); % shuffle the trial number
    
    for trialNo=1:length(ConditionList.Trial)
        
        TrialInfo=[]; TrialType=[]; LeftSide=[]; RightSide=[]; Correct=[];
        TrialInfo=ConditionList((ConditionList.Trial==trialNo),:);
        TrialType=TrialInfo.Condition{1};
        LeftSide=TrialInfo.Left{1};
        RightSide=TrialInfo.Right{1};
        Correct=TrialInfo.Winner{1};
        
       [win,RT,endGame,StimName,earning,chosenSide,chosenStim]=DetermineStimuli(Exprun,deck,directory,TrialType,LeftSide,RightSide,Correct,window,xCenter, yCenter, baseRect, squareXpos, numSquares,rightkey, leftkey,endcode,simulation,fontcolor);
        
        % organize results
        Results{trialNo,1}=Exprun;
        Results{trialNo,2}=trialNo;
        Results{trialNo,3}=TrialType;
        Results{trialNo,4}=StimName;
        Results{trialNo,5}=LeftSide;
        Results{trialNo,6}=RightSide;
        Results{trialNo,7}=Correct;
        Results{trialNo,8}=win;
        Results{trialNo,9}=RT;
        Results{trialNo,10}=earning;
        Results{trialNo,11}=chosenSide;
        Results{trialNo,12}=chosenStim;

        if endGame == 1
            break
        end
    end
    if Exprun < 3
        if simulation == 0
            DrawFormattedText(window, sprintf('%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s', ...
                'You are done with this block.', ...
                'In the next block, you will be presented with new symbols.', ...
                'Take a break before you start the next block.', ...
                'Press a key when you are ready to start.'), 'center', 'center',fontcolor,[100],[],[],[2]);
            Screen('Flip',window); KbStrokeWait;
        end
    end
    AllResults=[AllResults;Results];
end
toc
Screen('DrawText', window, sprintf( '%s', 'Study is over. Thanks for your participation! ' ), xCenter-400, yCenter,fontcolor);
Screen('Flip',window);
WaitSecs(1);
KbStrokeWait;
Screen('CloseAll');
EndTime = datestr(now);
display(['The participant earned ' num2str(sum(cell2mat(Results(:,end)))) ' dollars!']);
% save data in excel form and place in them subject folder
Table=table(AllResults(:,1),AllResults(:,2),AllResults(:,3),AllResults(:,4),AllResults(:,5),AllResults(:,6),AllResults(:,7),AllResults(:,8), AllResults(:,9), AllResults(:,10),AllResults(:,11),AllResults(:,12),...
    'VariableNames',{'RunNo','TrialNo','TrialType','StimulusName','LeftSide','RightSide','CorrectSide','Accuracy','RT','Earning','ChosenSide' ,'ChosenStimulus'});
writetable(Table,['Results',num2str(Session),'_' 'subject',num2str(subjectId),'_',date,'.xlsx']);

files = dir(['*_subject' num2str(subjectId) '*.xlsx']);
for f=1:length(files)
    movefile(fullfile(files(f).folder,files(f).name), datafileName)
end
