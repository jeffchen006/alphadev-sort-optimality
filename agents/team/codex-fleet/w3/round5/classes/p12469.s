# n=5 model=out iset=I1 prefix14_class=12469
mov S2, P1
cmp S2, P0
mov S0, P2
cmovle P1, P0
cmovge S2, P0
cmp P2, P3
cmovge S0, P3
cmovg P3, P2
cmp S0, S2
cmovge S1, S2
cmovg S2, S0
cmovg S0, S1
cmp P1, P3
cmovle P2, P3
