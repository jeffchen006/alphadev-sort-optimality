# n=5 model=out iset=I1 prefix14_class=8669
mov S2, P3
cmp P1, P3
cmovge S2, P1
cmovg P1, P3
mov S0, S2
cmp P2, P0
cmovle S1, P0
cmovle P0, P2
cmovl P2, S1
cmp P2, S2
cmovg S0, P2
cmovg P2, S2
cmp P0, P1
cmovg S2, P1
