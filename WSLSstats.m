% this script calculates win-stay, lose-shift behavior in Win and Loss
% trials separely. Read the xlsx file produced from the task and equate it
% to behtable. IndividualResults is the resulting table.

%behtable=readtable('Results1_subject2014_28-Jul-2021.xlsx');
ValenceData = WSLSStatTable(behtable);

WSLSstat=[];
for cValence = ["Gain", "Loss"]
    for run=1:3
        RunData=[]; RunData=ValenceData((ValenceData.RunNo==run & strcmp(ValenceData.TrialType,cValence)),:);
        WSLSstat.(cValence)(run,1)=size(RunData((strcmp(RunData.StayShift,"Stay") & strcmp(RunData.WinLose,"Win")),:),1)/length(RunData.RunNo);
        WSLSstat.(cValence)(run,2)=size(RunData((strcmp(RunData.StayShift,"Shift") & strcmp(RunData.WinLose,"Loss")),:),1)/length(RunData.RunNo);
    end
    
end

IndividualResults=table(WSLSstat.Gain(:,1), WSLSstat.Gain(:,2), WSLSstat.Loss(:,1), WSLSstat.Loss(:,2), 'VariableNames', {'GainTrial_WinStay','GainTrial_LoseShift','LossTrial_WinStay','LossTrial_LoseShift'}, ...
    'RowNames', {'PracticeRun', 'TestRun1','RestRun2'})




function ValenceData = WSLSStatTable(behtable)
%CALCSTATTABLE Summary of this function goes here
%   Detailed explanation goes here
behtable=behtable((behtable.Accuracy<999),:); % cleans the data from missed trials
%Loop over each set of images
ValenceData=[];
for cValence = ["Gain", "Loss"]
    BlockData=[];
    for cBlock = 1:3
        %Get data for this set of images
        cData=[];
        cData = behtable(strcmp(string(behtable.TrialType), cValence) & strcmp(string(behtable.RunNo), string(cBlock)), :);
        
        StayShift=[]; WinLose=[];
        %Each image is shown 28 times
        for cTimePoint = 1:size(cData,1)
            
            %Add StayShift
            if cTimePoint>1
                PrevChoice = cData.ChosenStimulus(cTimePoint-1);
                cChoice = cData.ChosenStimulus(cTimePoint);
                
                if strcmp(PrevChoice, cChoice)
                    StayShift{cTimePoint,1} = 'Stay';
                else
                    StayShift{cTimePoint,1} = 'Shift';
                end
                
                cTrialType = cData.TrialType(cTimePoint-1);
                cEarning = cData.Earning(cTimePoint-1);
                
                %Add Win/Loss factor
                if strcmp(cTrialType, "Gain") && cEarning==10
                    WinLose{cTimePoint,1} = 'Win';
                elseif strcmp(cTrialType, "Gain") && cEarning==0
                    WinLose{cTimePoint,1} ='Loss';
                elseif strcmp(cTrialType, "Loss") && cEarning==0
                    WinLose{cTimePoint,1} ='Win';
                elseif strcmp(cTrialType, "Loss") && cEarning==-10
                    WinLose{cTimePoint,1} = 'Loss';
                end
            else
                StayShift{cTimePoint,1}="NA";
                WinLose{cTimePoint,1}="NA";
            end
        end
        
        cData.StayShift=StayShift;
        cData.WinLose=WinLose;
        BlockData=[BlockData; cData];
    end
    ValenceData=[ValenceData;BlockData];
end

end


