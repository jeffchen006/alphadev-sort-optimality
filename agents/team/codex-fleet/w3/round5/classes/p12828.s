# n=5 model=out iset=I1 prefix14_class=12828
mov S0, P0
cmp P1, P0
cmovg P0, P1
mov S2, P2
cmovle S0, P1
cmp S2, P3
cmovge P2, P3
cmovge P3, S2
cmp S0, P2
cmovg S2, S0
cmovg S0, P2
mov S1, P3
cmovg P2, S2
cmp P0, S1
