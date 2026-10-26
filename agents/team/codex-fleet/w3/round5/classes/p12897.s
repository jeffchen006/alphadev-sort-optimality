# n=5 model=out iset=I1 prefix14_class=12897
cmp P3, P1
cmovg S0, P3
cmovle S0, P1
cmovge P3, P1
cmp P0, P2
cmovle S2, P2
cmovle P2, P0
cmovle P0, S2
mov S1, P2
cmp P2, P3
cmovl P2, P3
cmovle P3, S1
cmp S0, P0
mov P3, S0
