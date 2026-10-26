# n=5 model=out iset=I1 prefix14_class=5118
mov S0, P0
cmp P0, P2
cmovl P0, P2
cmovle P2, S0
cmp P1, P3
mov S0, P2
cmovg S1, P1
cmovge P1, P3
cmovle S1, P3
cmp P1, P2
cmovl P2, P1
cmovg S0, P1
mov P2, S0
mov S2, S1
