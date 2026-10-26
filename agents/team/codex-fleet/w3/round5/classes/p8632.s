# n=5 model=out iset=I1 prefix14_class=8632
cmp P0, P2
cmovle S0, P0
cmovge S0, P2
cmovge P2, P0
cmp P1, P3
cmovg P0, P1
cmovg P1, P3
mov S1, P2
cmovg P3, P0
cmp P3, P2
cmovg S1, P3
cmovg P3, P2
mov S1, S0
mov P2, P3
