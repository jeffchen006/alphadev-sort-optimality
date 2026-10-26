# n=5 model=out iset=I1 prefix14_class=37
mov S2, P0
cmp P3, S2
cmovle P0, P3
cmovl P3, S2
mov S1, P0
cmp P1, P2
cmovge S0, P2
cmovge P2, P1
cmovle S0, P1
cmp S1, S0
cmovle P0, S0
cmovg S1, S0
cmp P3, P2
mov S2, P3
