# n=5 model=out iset=I1 prefix14_class=12798
mov S0, P2
cmp P3, P2
mov S1, P0
cmovg P2, P3
cmovle S0, P3
cmp P0, P1
cmovg P0, P1
cmovg P1, S1
cmp S0, P0
cmovg S2, S0
cmovge S0, P0
cmovg P0, S2
mov S0, P2
cmp S0, P1
