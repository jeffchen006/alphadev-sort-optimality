# n=5 model=out iset=I1 prefix14_class=8237
cmp P2, P1
mov S0, P1
cmovle P1, P2
cmovl P2, S0
cmp P3, P0
cmovg S0, P0
cmovge P0, P3
cmovg P3, S0
mov S1, P1
cmp P1, P3
cmovg P1, P3
mov P1, P0
cmovle S1, P3
cmp P1, P2
