# n=5 model=out iset=I1 prefix14_class=1002
mov S2, P2
cmp P1, P2
cmovl P2, P1
cmovge S2, P1
mov S0, P3
cmp P3, P0
cmovge P3, P0
cmovg P0, S0
cmp P0, S2
mov S1, S2
mov P1, P3
cmovg S1, P0
cmovg P0, S2
cmp P2, P1
