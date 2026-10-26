# n=5 model=out iset=I1 prefix14_class=9228
mov S2, P0
cmp P2, P1
cmovg S0, P1
cmovge P1, P2
cmovg P2, S0
mov S1, P2
cmp P3, P0
cmovge S2, P3
cmovl P0, P3
cmp P2, P0
cmovge P2, P0
cmovle S1, P0
cmp S2, P1
cmovle P0, S2
