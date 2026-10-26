# n=5 model=out iset=I1 prefix14_class=1765
mov S2, P2
mov S1, P3
cmp P0, P2
cmovg P2, P0
cmovge P0, S2
cmp S1, P1
cmovg S1, P1
cmovle P3, P1
mov S0, P3
cmp S0, P2
cmovl P3, P2
cmovge S0, P2
cmp P0, S1
cmovle S2, P0
