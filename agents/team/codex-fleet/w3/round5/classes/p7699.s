# n=5 model=out iset=I1 prefix14_class=7699
cmp P1, P2
mov S2, P2
cmovg P2, P1
cmovle S2, P1
mov S1, P3
mov S0, S2
cmp S1, P0
cmovg P3, P0
cmovg P0, S1
cmp S2, P3
cmovle S0, P3
cmovg S2, P3
cmp P2, P0
cmovge S2, P2
