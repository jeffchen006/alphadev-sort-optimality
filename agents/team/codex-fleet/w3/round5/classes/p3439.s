# n=5 model=out iset=I1 prefix14_class=3439
cmp P0, P3
mov S2, P2
cmovg S0, P3
cmovg P3, P0
cmovg P0, S0
cmp P2, P1
cmovg P2, P1
cmovle S2, P1
mov P1, P0
cmp P2, P1
cmovg P1, P2
cmovge P2, P0
mov P0, S2
cmp P3, S2
