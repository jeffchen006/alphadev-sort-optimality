# n=5 model=out iset=I1 prefix14_class=9294
cmp P0, P3
cmovg S0, P3
cmovle S0, P0
cmovge P3, P0
cmp P2, P1
cmovle S1, P1
cmovl P1, P2
cmovle P2, S1
mov S2, S0
cmp P1, S0
cmovg S2, P1
cmovle S0, P1
mov P1, P3
cmp P1, P2
