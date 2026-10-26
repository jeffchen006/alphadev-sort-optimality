# n=5 model=out iset=I1 prefix14_class=3452
mov S0, P1
cmp P0, S0
cmovg S0, P0
mov S1, P2
cmovg P0, P1
cmp S1, P3
cmovg P2, P3
cmovle S1, P3
cmp P2, P0
mov S2, S1
cmovge P3, P0
cmovg P0, P2
cmovge P2, P3
cmp S0, S1
