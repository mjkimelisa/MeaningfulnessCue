% MeaningfulnessCue5v2.m - intact/scrambled intermixed, object random x

cd('/Users/elisabeth/Library/CloudStorage/GoogleDrive-kmin0531@yonsei.ac.kr/내 드라이브/CNL/Meeting/MeaningfulnessCue');
work_dir = pwd;

ClockRandSeed;

% 설정 =====================================================================
TRG = 6; % 물체 6개 중 검사할 물체 위치
CUE = 2; % Cue(NoCue, Cue)
STIM = 2; % 자극 종류 2개(intact, scrambled)
REP = 2; % 각 조건당 48시행, 뒤에 cueGrp으로 loop돌리거라 2번 반복으로 설정
nTRIAL = TRG * CUE * STIM * REP;

xIndex = 0:(nTRIAL-1);

oTrg = mod(xIndex, TRG) + 1; % 여섯 개의 자극 중 목표 타겟 위치

% 총 8가지 spreadsheets가 필요(연습시행 4, 본시행4/ 버전 2개씩 갖음)
% 물체, 단서 ================================================================
fJPG = dir('OBJECTS1400/*.jpg');

randIdx = randperm(numel(fJPG));
randJPG = fJPG(randIdx);

ChangeJPG = {randJPG(1:200).name};

fJPG = sort({randJPG(201:end).name}); % abc 순서로 배열
idxJPG = reshape(1:1200, 400, 3); % 동일한 하위범주 물체들이 한 시행에서 동시에 등장하지 않도록 인덱싱

cueType = {'NO', 'AR'}; % NO = No-Arrow, AR = Arrow
stmType = {'INT', 'SCR'};
sufType = {'', '_scram'};

% Spreadsheet =============================================================
for setGrp = 1:2

cntCase = 0; % 제시 자극 index 용도
chaCase = 0; % 변화 자극 index 용도

for cueGrp = 1:2 
for trialGrp = 1:2

if trialGrp == 1 % practice trial
    verName = "p";
    disName = "prac";
    totalN = 2; % 큐 조건당 2시행씩
    cTrg = [randperm(6, 2);randperm(6, 2)];
    dTrg = reshape(repelem([1 2], totalN), 2, []); % 1행은 No-Arrow, 2행은 Arrow
else % main trial
    verName = "v";
    disName = "main";
    totalN = nTRIAL;
    cTrg = [oTrg; oTrg]; % 1행은 No-Arrow, 2행은 Arrow
    dTrg = reshape(repelem([1 2], totalN), 2, []); % 1행은 No-Arrow, 2행은 Arrow
end
    
% 파일 =====================================================================
% Write file.
SSver = sprintf("%s%02d%s%d", verName, setGrp+2*(cueGrp-1), cueType{setGrp}, cueGrp);
dataFile = fopen(fullfile(work_dir, sprintf("%s.csv", SSver)), 'w');

% Write header
fprintf(dataFile, 'SSver,display,stim,maxn,trial,d1obj1,d1obj2,d1obj3,d1obj4,d1obj5,d1obj6,');
fprintf(dataFile, 'd2obj1,d2obj2,d2obj3,d2obj4,d2obj5,d2obj6,d3obj1,d3obj2,d3obj3,d3obj4,d3obj5,d3obj6,');
fprintf(dataFile, 'cue,tarLoc,tarDis,change,proc1,proc2\n');

% Intro ===================================================================
if trialGrp == 1
    fprintf(dataFile, '%s,pracIntro,,,,,,,,,,,,,,,,,,,,,,,,,,a0%s%s.jpg,a0%s%s.jpg\n', SSver, stmType{1}, cueType{setGrp}, stmType{2}, cueType{setGrp});
else
    fprintf(dataFile, '%s,mainIntro,,,,,,,,,,,,,,,,,,,,,,,,,,a0%s%s.jpg,a0%s%s.jpg\n', SSver, stmType{1}, cueType{setGrp}, stmType{2}, cueType{setGrp});
end
    
% Trial ===================================================================
for stmGrp = 1:2
for it = 1:totalN
    % SSver,display,stim,maxn,trial
    fprintf(dataFile, '%s,%s,%s,%d,%d,', SSver, disName, stmType{stmGrp},totalN*2, it);
    
    % remember & forget condition
    if dTrg(cueGrp, it) == 1
        if cTrg(cueGrp, it) <= 3
            % d1) obj1,obj2,obj3,obj4,obj5,obj6
            cntCase = cntCase + 1;
            wImageSet(dataFile, fJPG(idxJPG(cntCase, 1:3)), sufType{stmGrp});
            wBlanks(dataFile, 3);
            % d2) obj1,obj2,obj3,obj4,obj5,obj6
            cntCase = cntCase + 1;
            wBlanks(dataFile, 3);
            wImageSet(dataFile, fJPG(idxJPG(cntCase, 1:3)), sufType{stmGrp});
        else
            % d1) obj1,obj2,obj3,obj4,obj5,obj6
            cntCase = cntCase + 1;
            wBlanks(dataFile, 3);
            wImageSet(dataFile, fJPG(idxJPG(cntCase, 1:3)), sufType{stmGrp});
            % d2) obj1,obj2,obj3,obj4,obj5,obj6
            cntCase = cntCase + 1;
            wImageSet(dataFile, fJPG(idxJPG(cntCase, 1:3)), sufType{stmGrp});
            wBlanks(dataFile, 3);
        end
    elseif dTrg(cueGrp, it) == 2
        if cTrg(cueGrp, it) <= 3
            % d1) obj1,obj2,obj3,obj4,obj5,obj6
            cntCase = cntCase + 1;
            wBlanks(dataFile, 3);
            wImageSet(dataFile, fJPG(idxJPG(cntCase, 1:3)), sufType{stmGrp});
            % d2) obj1,obj2,obj3,obj4,obj5,obj6
            cntCase = cntCase + 1;
            wImageSet(dataFile, fJPG(idxJPG(cntCase, 1:3)), sufType{stmGrp});
            wBlanks(dataFile, 3);
        else
            % d1) obj1,obj2,obj3,obj4,obj5,obj6
            cntCase = cntCase + 1;
            wImageSet(dataFile, fJPG(idxJPG(cntCase, 1:3)), sufType{stmGrp});
            wBlanks(dataFile, 3);
            % d2) obj1,obj2,obj3,obj4,obj5,obj6
            cntCase = cntCase + 1;
            wBlanks(dataFile, 3);
            wImageSet(dataFile, fJPG(idxJPG(cntCase, 1:3)), sufType{stmGrp});
        end
    end
    
    % sample3 = test) obj1,obj2,obj3,obj4,obj5,obj6 + change
    for tt = 1:6
        if cTrg(cueGrp, it) == tt
            fprintf(dataFile, 'change,');
        else
            fprintf(dataFile, 'd%dobj%d,', dTrg(cueGrp, it), tt);
        end
    end
    
    % cue(No-arrow:0, Arrow:1), tarLoc, tarDis, change
    chaCase = chaCase + 1;
    ctmp = ChangeJPG{chaCase};
    fprintf(dataFile, '%d,%d,%d,%s%s.jpg,,\n', setGrp-1, cTrg(cueGrp, it), dTrg(cueGrp, it), ctmp(1:end-4), sufType{stmGrp});

end
end

% Bye =====================================================================
fprintf(dataFile, '%s,%sBye', SSver, disName);

fclose('all');

end
end
end


% 보조 함수 ================================================================
function wImageSet(fileID, images, suffix)
    for i = 1:numel(images)
        fprintf(fileID, '%s%s.jpg,', images{i}(1:end-4), suffix);
    end
end

function wBlanks(fileID, count)
    fprintf(fileID, repmat('blank.jpg,', 1, count));
end
