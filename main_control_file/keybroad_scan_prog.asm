PUBLIC KEYBOARD_SCAN ;扫描键盘，读入一个键值
EXTRN CODE (DELAY_KEYBOARD)
EXTRN CODE (DISPLAY_NUMBER_CONTENT)
KEYBOARD_SCAN:
JB 01H,KEYBOARD_RETURN ;上一位扫描进来的信息还没取走，等待取走
SCAN:
LCALL DISPLAY_NUMBER_CONTENT
MOV P1,#0FH ;行线输出全0，列线输出全1
MOV A,P1 ;读入列线值
CJNE A,#0FH,BUTTON_DOWN
AJMP SCAN
BUTTON_DOWN: ;检测到有按键按下，进行消抖
MOV P1,#0FH
LCALL DELAY_KEYBOARD
MOV A,P1 ;再次检测有没有按下
CJNE A,#0FH, REAL_BUTTON_DOWN ;按键按下
AJMP SCAN ;没有按键按下，返回重新扫描
REAL_BUTTON_DOWN:
MOV R7,A ;将含0的列保存下来
MOV P1,#0F0H ;行线输出全1，列线输出全0
MOV A,P1 ;读入行线值
ORL A,R7 ;赋直接键值并存入R7
XCH A,R7
BUTTON_NOT_UP:
LCALL DISPLAY_NUMBER_CONTENT
MOV P1,#0FH ;开始检测按钮是否松开并消抖
MOV A,P1
CJNE A,#0FH,BUTTON_NOT_UP ;按键还没有松开
LCALL DELAY_KEYBOARD
MOV P1,#0FH
MOV A,P1
CJNE A,#0FH,BUTTON_NOT_UP
SETB 01H
KEYBOARD_RETURN:
RET
END