PUBLIC MATRIX_SENDBYTE
MATRIX_SENDBYTE:
MOV A,51H
MOV B,#08H
SEND_BYTE_LOOP:
RLC A
MOV P3.4,C
SETB SRCLK ;���ߵ�ƽ����������
NOP
NOP
CLR SRCLK
DJNZ B,SEND_BYTE_LOOP
RET
END