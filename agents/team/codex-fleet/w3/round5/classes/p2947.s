# n=5 model=out iset=I1 prefix14_class=2947
cmp P2, P0
mov S2, P3
mov S0, P2
cmovge S0, P0
cmovg P0, P2
cmp P1, P3
cmovg S2, P1
cmovge P1, P3
cmovg P3, S2
cmp P0, S2
cmovl P3, P0
cmovle P0, S2
cmp S0, P1
cmovg S2, P1
