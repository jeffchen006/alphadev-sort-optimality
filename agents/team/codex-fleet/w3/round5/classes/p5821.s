# n=5 model=out iset=I1 prefix14_class=5821
cmp P2, P0
mov S0, P0
cmovle P0, P2
cmovg S0, P2
cmp P1, P3
mov S2, S0
cmovle P2, P1
cmovle P1, P3
mov S1, P0
cmovl P3, P2
cmp S1, P3
cmovge P0, P3
cmovle S1, P3
cmp S2, P1
