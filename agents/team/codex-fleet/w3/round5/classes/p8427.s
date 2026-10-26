# n=5 model=out iset=I1 prefix14_class=8427
mov S1, P0
cmp S1, P2
cmovge P0, P2
mov S0, P1
cmovg P2, S1
cmp P1, P3
cmovg S0, P3
cmovge P3, P1
cmp P3, P2
cmovg P1, P2
cmovge P2, P3
cmovg P3, P1
cmp S0, P0
cmovle S1, P0
