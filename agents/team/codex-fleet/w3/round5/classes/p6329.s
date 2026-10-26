# n=5 model=out iset=I1 prefix14_class=6329
mov S1, P1
cmp P1, P2
cmovge S1, P2
cmovge P2, P1
cmp P0, P3
cmovle S0, P0
cmovle P0, P3
mov S2, P0
cmovl P3, S0
cmp P0, P2
cmovl P0, P2
cmovg S2, P2
cmp P3, S1
cmovg P2, S1
