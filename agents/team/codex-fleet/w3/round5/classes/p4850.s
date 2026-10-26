# n=5 model=out iset=I1 prefix14_class=4850
mov S2, P2
cmp P1, P2
cmovg P2, P1
cmovle S2, P1
mov S0, P0
cmp S0, P3
cmovg S0, P3
cmovg P3, P0
cmp S2, S0
mov S1, S2
cmovge S1, S0
cmovg S0, S2
mov S1, P2
cmp P3, P2
