# n=5 model=out iset=I1 prefix14_class=1356
cmp P3, P2
mov S1, P2
cmovle S1, P3
cmovg P2, P3
cmp P0, P1
mov S0, P1
cmovg P1, P0
cmovle S0, P0
cmp P1, P2
mov P3, P2
cmovge P2, P1
cmovg P1, P3
mov P2, S0
cmp S1, S0
