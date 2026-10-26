# n=5 model=out iset=I1 prefix14_class=6754
cmp P1, P0
mov S0, P1
mov S2, P2
cmovg P1, P0
cmovle S0, P0
cmp S2, P3
cmovg P2, P3
cmovle S2, P3
cmp S0, S2
cmovg P3, S0
cmovge S0, S2
cmovg S2, P3
cmp P1, P2
cmovge P3, P1
