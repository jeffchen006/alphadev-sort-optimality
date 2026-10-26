# n=5 model=out iset=I1 prefix14_class=3601
mov S1, P3
cmp P3, P2
cmovle S1, P2
cmovle P2, P3
mov P3, P0
cmp P1, P3
cmovl P3, P1
cmovle P1, P0
cmovle P0, P3
cmp P2, P0
cmovle P3, P2
cmovl P2, P0
cmp P1, S1
cmovl P3, P1
