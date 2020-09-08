PUBLIC END_RACE
EXTRN CODE (DISPLAY_MATRIX_LED)
END_RACE:
CLR EX0
CLR EX1 ;禁止计数
SETB TR1 ;开始计时，播放音乐
SETB TR0 ;蜂鸣器响
;判断谁赢
MOV A,30H
CJNE A,31H,NEED_JUDGEMENT
MOV 40H,#10H ;平手
AJMP JUDGE_END
NEED_JUDGEMENT:
CLR C
SUBB A,31H
JC JUDGE_END
MOV 40H,#08H ;B队赢
JUDGE_END:
;计算点阵字符
;赢的队伍 (存于41H~48H)
MOV R2,#08H
MOV R1,#41H
MOV A,#90H
ADD A,40H
MOV R0,A
MOVE_MATRIX_CONTENT1:
MOV A,@R0
MOV @R1,A
INC R1
INC R0
DJNZ R2,MOVE_MATRIX_CONTENT1
;两队分数（存于49H~50H）
JB 03H,HEX_MATRIX
MOV A,31H
MOV B,#10
DIV AB
MOV R5,A
ADD A,R5
ADD A,#0A8H
MOV R0,A ;A队十位点阵地址
XCH A,B
MOV R5,A
ADD A,R5
ADD A,#0A8H
MOV R2,A ;A队个位点阵地址
MOV A,30H
MOV B,#10
DIV AB
MOV R5,A
ADD A,R5
ADD A,#0A8H
MOV R1,A ;B队十位点阵地址
XCH A,B
MOV R5,A
ADD A,R5
ADD A,#0A8H
MOV R3,A ;B队个位点阵地址
AJMP PREPARE_MATRIX_CONTENT_LOOP
HEX_MATRIX:
MOV A,31H
MOV B,#16
DIV AB
MOV R5,A
ADD A,R5
ADD A,#0A8H
MOV R0,A ;A队十六位点阵地址
XCH A,B
MOV R5,A
ADD A,R5
ADD A,#0A8H
MOV R2,A ;A队个位点阵地址
MOV A,30H
MOV B,#16
DIV AB
MOV R5,A
ADD A,R5
ADD A,#0A8H
MOV R1,A ;B队十六位点阵地址
XCH A,B
MOV R5,A
ADD A,R5
ADD A,#0A8H
MOV R3,A ;B队个位点阵地址
PREPARE_MATRIX_CONTENT_LOOP:
MOV 08H,#49H ;1区R0指向目标地址（前）
MOV 09H,#4AH ;1区R1指向目标地址（后）
MOV 0AH,#2 ;1区R2作为小循环计数器
MOV 0BH,#2 ;1区R3作为大循环计数器
MATRIX_CONTENT_LOOP:
MOV A,@R0 ;后四位
MOV B,@R1
ANL A,#0FH
SWAP A
ANL B,#0FH
ORL A,B
SETB RS0
MOV @R1,A
INC R1
INC R1
CLR RS0
MOV A,@R1 ;前四位
MOV B,@R0
ANL A,#0F0H
SWAP A
ANL B,#0F0H
ORL A,B
SETB RS0
MOV @R0,A
INC R0
INC R0
CLR RS0
INC R0
INC R1
DJNZ 0AH,MATRIX_CONTENT_LOOP
MOV R0,02H
MOV R1,03H
MOV 0AH,#02H
DJNZ 0BH,MATRIX_CONTENT_LOOP
DISPLAY_MATCH_RESULT:
SETB P3.0 ;检测是否要开关音乐
JB P3.0,DISPLAY_MATRIX_CONTENT
LCALL DELAY_KEYBOARD ;消抖
SETB P3.0
JB P3.0,DISPLAY_MATRIX_LED
CPL TR0
CHECK_CHANGE_MUSIC_UP:
LCALL DISPLAY_MATRIX_LED
SETB P3.0
JNB P3.0,CHECK_CHANGE_MUSIC_UP
LCALL DELAY_KEYBOARD ;消抖
SETB P3.0
JNB P3.0,CHECK_CHANGE_MUSIC_UP 
DISPLAY_MATRIX_CONTENT: 
LCALL DISPLAY_MATRIX_LED
SETB P3.1 ;检测是否重头开始
JB P3.1,DISPLAY_MATCH_RESULT
LCALL DELAY_KEYBOARD ;消抖
SETB P3.1
JB P3.1,DISPLAY_MATCH_RESULT
MOV 51H,#00H
LCALL MATRIX_SENDBYTE ;关闭点阵显示
SETB RCLK
NOP
NOP
CLR RCLK
SCAN_RELEASE_RESET:
SETB P3.1
JB P3.1,SCAN_RELEASE_RESET
LCALL DELAY_KEYBOARD ;消抖
SETB P3.1
JB P3.1,SCAN_RELEASE_RESET
RET
END