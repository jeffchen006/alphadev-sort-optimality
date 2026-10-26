# n=5 model=out iset=I1 prefix14_class=6217
mov S1, P0
cmp P0, P3
cmovle P0, P3
mov S0, P2
cmovge S1, P3
cmp P1, S0
cmovle S0, P1
mov S2, P0
cmovg P2, P1
cmp P0, P2
cmovg S2, P2
cmovl P0, P2
cmp S1, S0
cmovge P2, S0
