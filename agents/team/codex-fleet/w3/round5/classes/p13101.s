# n=5 model=out iset=I1 prefix14_class=13101
cmp P0, P1
mov S2, P2
mov S0, P1
cmovg S0, P0
cmovg P0, P1
cmp P3, S2
cmovg P2, P3
cmovle S2, P3
cmp S2, P0
cmovge P1, S2
cmovge S2, P0
cmovg P0, P1
mov P3, P2
cmp S0, P2
