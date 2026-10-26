# n=5 model=out iset=I1 prefix14_class=4095
mov S0, P0
mov S1, P2
cmp P3, S0
cmovle P0, P3
cmovg S0, P3
cmp P1, S1
cmovge P2, P1
cmovg P1, S1
cmp P0, P1
cmovg P3, P1
cmovge P1, P0
cmovg P0, P3
cmp P2, S0
mov S2, S0
