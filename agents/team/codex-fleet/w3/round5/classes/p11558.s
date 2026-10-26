# n=5 model=out iset=I1 prefix14_class=11558
cmp P3, P1
mov S1, P1
cmovg P1, P3
cmovle S1, P3
cmp P2, P0
cmovle S0, P0
cmovle P0, P2
cmovle P2, S0
mov P3, S1
cmp P0, S1
cmovle S1, P0
mov S1, P2
cmovge P3, P0
cmovl P0, P3
