# n=5 model=out iset=I1 prefix14_class=2777
mov S0, P0
cmp P3, P2
cmovle S1, P2
cmovg S1, P3
cmovg P3, P2
cmp P1, S0
cmovg S0, P1
cmovg P1, P0
cmp S1, S0
cmovge S2, S0
cmovge S0, S1
cmovle S2, S1
mov S0, S2
cmp P3, P1
