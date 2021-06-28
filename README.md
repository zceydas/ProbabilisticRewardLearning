# ProbabilisticRewardLearning

%% Probabilistic Reward Learning Task
% Run this study by dragging/dropping RLwrapper function on the Matlab
% command window. Psychtoolbox is a requirement. 

% Upon prompt: Enter subject ID and then indicate which session (test or re-test) it is.

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
