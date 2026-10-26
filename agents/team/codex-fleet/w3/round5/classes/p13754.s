# n=5 model=out iset=I1 prefix14_class=13754
cmp P2, P1
mov S2, P2
cmovle S2, P1
cmovge P2, P1
cmp P3, P0
mov S1, P0
cmovg S1, P3
cmovg P3, P0
cmp S2, S1
cmovge P0, S2
cmovge S2, S1
cmovg S1, P0
cmp P3, P2
cmovle S0, P3
