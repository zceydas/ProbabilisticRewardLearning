% cTSVfile = subjects.HC.POMU002A9E62F2779ACD.RawData.eventsTSV;
% cStatTable = calcStatTable_temp(cTSVfile);
function statTable = calcStatTable(behtable)
%CALCSTATTABLE Summary of this function goes here
%   Detailed explanation goes here
behtable=behtable((behtable.Accuracy<999),:); % cleans the data from missed trials
%Loop over each set of images
for cValence = ["Gain", "Loss"]
    for cBlock = 1:3
        %Get data for this set of images
        cData = behtable(strcmp(string(behtable.TrialType), cValence) & strcmp(string(behtable.RunNo), string(cBlock)), :);
        
        temp_statTable = table('Size', [0 10], ...
            'VariableTypes', ["double", "double", "double", "double", "string", "double", "double", "string", "string", "string"], ...
            'VariableNames', ["TimePoint", "trial_number", "block", "mis", "trial_type", "response_time", "outcome", "correct_response", "StayShift", "WinLose"]);
        
        %Each image is shown 28 times
        for cTimePoint = 1:28
            %Find correct columns correct data
            addStruct.TimePoint         = cTimePoint;
            addStruct.trial_number      = str2double(string(cData{strcmp(string(cData.event_type), 'cue'), "trial_number"}(cTimePoint)));
            addStruct.block             = str2double(string(cData{strcmp(string(cData.event_type), 'cue'), "block"}(cTimePoint)));
            addStruct.mis               = str2double(string(cData{strcmp(string(cData.event_type), 'cue'), "mis"}(cTimePoint)));
            addStruct.trial_type        = string(cData{strcmp(string(cData.event_type), 'cue'), "trial_type"}(cTimePoint));
            addStruct.correct_response  = string(cData{strcmp(string(cData.event_type), 'cue'), "correct_response"}(cTimePoint));
            
            %Deal with missing data
            if addStruct.mis
                addStruct.response_time  = NaN;
                addStruct.outcome        = NaN;
            else %Add outcome and response time if there is a response
                cRow = str2double(string(cData.trial_number)) == addStruct.trial_number;
                addStruct.response_time  = str2double(string(cData{strcmp(string(cData.event_type), 'response') & cRow, "response_time"}));
                addStruct.outcome        = str2double(string(cData{strcmp(string(cData.event_type), 'outcome') & cRow, "outcome"}));
            end
            
            %Add StayShift
            if cTimePoint>1
                PrevChoice = temp_statTable{cTimePoint-1, "correct_response"};
                cChoice = addStruct.correct_response;
                if strcmp(PrevChoice, cChoice)
                    addStruct.StayShift = "Stay";
                else
                    addStruct.StayShift = "Shift";
                end
            else
                addStruct.StayShift = missing;
            end
            
            
            %Add Win/Loss factor
            if strcmp(addStruct.trial_type, "Gain") && addStruct.outcome==10
                addStruct.WinLose = "Win";
            elseif strcmp(addStruct.trial_type, "Gain") && addStruct.outcome==0
                addStruct.WinLose = "Loss";
            elseif strcmp(addStruct.trial_type, "Loss") && addStruct.outcome==0
                addStruct.WinLose = "Win";
            elseif strcmp(addStruct.trial_type, "Loss") && addStruct.outcome==-10
                addStruct.WinLose = "Loss";
            else %Case of missing
                addStruct.WinLose = "Loss";
            end
            
            addTable = struct2table(addStruct);
            temp_statTable = [temp_statTable; addTable];
        end
        
        %Add minus one and two trials ago
        WinLoseM1 = [NaN(1,1); temp_statTable.WinLose(1:27)];
        WinLoseM2 = [NaN(2,1); temp_statTable.WinLose(1:26)];
        WinLoseM3 = [NaN(3,1); temp_statTable.WinLose(1:25)];
        addTable = table(WinLoseM1, WinLoseM2, WinLoseM3);
        tempStruct.(strcat(cValence, string(cBlock))) = [temp_statTable, addTable];
    end
end

%Add 4 tables together
statTable = sortrows([tempStruct.Gain1; tempStruct.Gain2; tempStruct.Loss1; tempStruct.Loss2], "trial_number");

end
