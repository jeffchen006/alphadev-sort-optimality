# n=5 model=out iset=I1 prefix14_class=590
cmp P0, P1
mov S2, P0
mov S1, P2
cmovg S2, P1
cmovl P0, P1
cmovg P1, P0
cmp S1, P3
cmovge P2, P3
cmovge P3, S1
cmp P3, P1
cmovle P1, P3
cmovge P0, P3
cmp S2, P2
cmovge S0, S2
