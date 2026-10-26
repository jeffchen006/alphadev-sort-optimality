# n=5 model=out iset=I1 prefix14_class=7887
mov S2, P2
cmp P2, P0
cmovge S2, P0
cmovg P0, P2
cmp P3, P1
mov P2, P3
cmovge P2, P1
cmovle P3, P1
cmp P2, S2
cmovge S0, P2
cmovg P2, S2
cmovg S2, S0
cmp P3, P0
mov S1, P3
