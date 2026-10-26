# n=5 model=out iset=I1 prefix14_class=4755
cmp P1, P2
cmovg S2, P1
cmovle S2, P2
cmovg P1, P2
cmp P0, P3
mov S0, P3
cmovge S0, P0
cmovge P0, P3
mov P2, P1
cmp P0, P1
cmovge P2, P0
cmovg P0, P1
mov P3, P2
mov P0, S2
