# n=5 model=out iset=I1 prefix14_class=2776
cmp P0, P2
mov S0, P0
cmovle S0, P2
cmovg P0, P2
mov S2, P1
cmp P3, S2
cmovg P1, P3
cmovg P3, S2
cmp S0, P1
cmovge S2, P1
mov S1, P0
cmovg P1, S0
cmovge S0, S2
cmp P3, P0
