# n=5 model=out iset=I1 prefix14_class=13166
cmp P1, P0
cmovge S2, P1
mov S0, P2
cmovg P1, P0
cmovg P0, S2
mov S1, P1
cmp P3, S0
cmovge P2, P3
cmovg P3, S0
cmp P3, P1
cmovg S1, P3
cmovge P3, P1
cmp P0, P2
cmovle S0, P0
