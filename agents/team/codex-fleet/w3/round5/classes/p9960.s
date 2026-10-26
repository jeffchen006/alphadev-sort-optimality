# n=5 model=out iset=I1 prefix14_class=9960
cmp P1, P0
cmovge S2, P0
cmovle S2, P1
cmovg P0, P1
cmp P3, P2
cmovg S0, P3
cmovg P3, P2
mov P1, S2
cmovg P2, S0
cmp P0, P2
cmovg S1, P0
cmovge P0, P2
cmovg P2, S1
cmp P1, P3
