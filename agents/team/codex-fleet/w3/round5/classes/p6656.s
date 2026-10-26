# n=5 model=out iset=I1 prefix14_class=6656
cmp P0, P2
cmovge S0, P2
mov S2, P1
cmovge P2, P0
cmovg P0, S0
cmp P3, P1
cmovg P1, P3
cmovge P3, S2
cmp P1, P2
cmovg S1, P1
cmovle S1, P2
cmovg P1, P2
mov S2, P0
cmp P3, S2
