# n=5 model=out iset=I1 prefix14_class=8629
cmp P2, P0
cmovg S0, P0
cmovge P0, P2
cmovle S0, P2
cmp P3, P1
cmovge P2, P3
cmovg P3, P1
mov S1, S0
cmovge P1, P2
cmp P1, P0
cmovg P2, P0
cmovg P0, P1
cmovg P1, P2
cmp S1, P3
