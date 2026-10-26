# n=5 model=out iset=I1 prefix14_class=13903
cmp P0, P3
cmovg S0, P3
cmovg P3, P0
mov S1, P1
cmovle S0, P0
cmp P2, S1
cmovge P1, P2
cmovge P2, S1
cmp P3, P1
cmovge S1, P1
cmovg P1, P3
cmovg P3, S1
cmp P2, S0
mov S2, P2
