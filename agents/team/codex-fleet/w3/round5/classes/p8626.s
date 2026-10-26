# n=5 model=out iset=I1 prefix14_class=8626
mov S0, P0
cmp P3, P0
cmovg P0, P3
cmovle S0, P3
mov S1, S0
cmp P2, P1
mov P3, P2
cmovge P2, P1
cmovge P1, P3
cmp P1, P0
cmovg P3, P0
cmovg P0, P1
cmovg P1, P3
cmp S1, P2
