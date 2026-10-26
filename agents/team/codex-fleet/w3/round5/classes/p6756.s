# n=5 model=out iset=I1 prefix14_class=6756
mov S0, P1
mov S2, P2
cmp P1, P3
cmovle P1, P3
cmovg S0, P3
cmp S2, P0
cmovle S2, P0
cmovg P2, P0
mov P0, P1
cmp P1, S2
cmovge P1, S2
cmovge S2, P0
cmp P2, S0
cmovl P0, S0
