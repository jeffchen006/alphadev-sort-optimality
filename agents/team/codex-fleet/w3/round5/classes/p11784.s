# n=5 model=out iset=I1 prefix14_class=11784
cmp P1, P2
cmovge S1, P2
mov S2, P0
cmovg P2, P1
cmovg P1, S1
cmp P3, S2
cmovle S2, P3
cmovg P0, P3
cmp P2, P0
cmovg S0, P0
cmovg P0, P2
cmovg P2, S0
cmp S2, P1
cmovg S1, S2
