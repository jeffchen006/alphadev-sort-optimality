# n=5 model=out iset=I1 prefix14_class=12745
mov S1, P1
cmp P3, P1
cmovg P1, P3
cmovle S1, P3
mov S0, P2
cmp P2, P0
cmovl P2, P0
cmovle P0, S0
cmp P0, S1
cmovge S2, S1
cmovg S1, P0
cmovg P0, S2
cmp P2, P1
mov P0, S1
