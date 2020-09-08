PUBLIC TEAM_A_SCORE
PUBLIC TEAM_B_SCORE
EXTRN CODE (DELAY_KEYBOARD)
TEAM_A_SCORE: ;按下第三个键，是A方得分
JB 02H,DO_NOT_ADD_A ;比赛暂停
CLR 10H
LCALL DELAY_KEYBOARD ;消抖
JNB 10H,DO_NOT_ADD_A ;没有按下
CLR 10H
PUSH 0E0H ;保护累加器
MOV A,31H
JB 03H,A_ADDABLE ;十六进制无需清零
CJNE A,#99,A_ADDABLE
MOV 31H,#00H ;计分到达99分，清零
AJMP A_NOT_ADDABLE_TREATED
A_ADDABLE:
INC 31H
A_NOT_ADDABLE_TREATED:
POP 0E0H ;恢复累加器内容
SCAN_A:
LCALL DISPLAY_NUMBER_CONTENT
CLR 10H
JB 10H,SCAN_A
LCALL DELAY_KEYBOARD ;消抖
CLR 10H
JB 10H,SCAN_A
DO_NOT_ADD_A:
RET
TEAM_B_SCORE: ;按下第四个键，是B方得分
JB 02H,DO_NOT_ADD_B ;比赛暂停
CLR 11H
LCALL DELAY_KEYBOARD ;消抖
JNB 11H,DO_NOT_ADD_B ;没有按下
PUSH 0E0H ;保护累加器
MOV A,30H
JB 03H,B_ADDABLE ;十六进制无需清零
CJNE A,#99,B_ADDABLE
MOV 30H,#00H ;计分到达99分，清零
AJMP B_NOT_ADDABLE_TREATED
B_ADDABLE:
INC 30H
B_NOT_ADDABLE_TREATED:
POP 0E0H ;恢复累加器内容
SCAN_B:
LCALL DISPLAY_NUMBER_CONTENT
CLR 11H
JB 11H,SCAN_B
LCALL DELAY_KEYBOARD ;消抖
CLR 11H
JB 11H,SCAN_B
DO_NOT_ADD_B:
RET
END