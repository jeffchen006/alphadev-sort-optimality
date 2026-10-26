# n=5 model=out iset=I1 prefix14_class=9867
cmp P1, P0
cmovge S2, P0
mov S0, P2
cmovg P0, P1
cmovg P1, S2
cmp P3, P2
cmovg S0, P3
cmovge P3, P2
mov S1, S0
cmp P0, S0
cmovle S1, P0
mov P2, P1
cmovge S0, P0
mov P0, S1
