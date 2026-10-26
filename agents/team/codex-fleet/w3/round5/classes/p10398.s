# n=5 model=out iset=I1 prefix14_class=10398
cmp P3, P1
cmovge S1, P3
cmovg P3, P1
cmovg P1, S1
cmp P2, P0
mov S0, P0
cmovge S0, P2
cmovg P2, P0
cmp P1, S0
cmovle S2, P1
cmovge S2, S0
cmovg S0, P1
mov S0, P3
mov P0, S2
