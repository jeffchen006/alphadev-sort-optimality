# n=5 model=out iset=I1 prefix14_class=2741
mov S0, P1
mov S1, P0
cmp S1, P2
cmovg S1, P2
cmovge P2, P0
cmp P3, P1
cmovl P1, P3
cmovle P3, S0
cmp P3, P2
cmovle S2, P3
cmovle P3, P2
mov P0, P1
cmovl P2, S2
mov S0, P2
